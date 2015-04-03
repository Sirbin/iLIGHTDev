Type=Activity
Version=1.50
FullScreen=False
IncludeTitle=True
@EndOfDesignText@
'Activity module
Sub Process_Globals
	Dim blobColumns As Map
End Sub

Sub Globals
	Dim tableFields As EditText
	Dim WebView1 As WebView
	Dim Image1 As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("Table")
	'Resize WebView to fill the screen
	WebView1.Width = 100%x - WebView1.Left
	WebView1.Height = 100%y - WebView1.Top
	blobColumns.Initialize
	Image1.Initialize("Image1")
	Image1.Visible = False
	Activity.AddView(Image1, 10dip, 10dip, 100%x - 20dip, 100%y - 20dip)
	LoadTable
End Sub

Sub LoadTable
	Dim t As List
	t = DBUtils.ExecuteMemoryTable(Main.SQL, "PRAGMA table_info ('" & Main.SelectedTable & "')", _
		Null, 0)
	Dim sb, query As StringBuilder
	query.Initialize
	query.Append("SELECT ")
	sb.Initialize
	sb.Append(Main.SelectedTable).Append(" fields:")
	For i = 0 To t.Size - 1
		Dim values() As String
		values = t.Get(i) 't is a list of arrays
		sb.Append(CRLF)
		sb.Append(values(1)).Append(": ").Append(values(2))
		If values(2) <> "BLOB" Then
			query.Append("[").Append(values(1)).Append("]")
		Else
			'This is a BLOB column. Don't try to convert it to string as it will fail.
			blobColumns.Put(i, values(1))
			query.Append("'Click to see image' AS ").Append("[").Append(values(1)).Append("]")
		End If
		query.Append(",")
	Next
	tableFields.Text = sb.ToString
	query.Remove(query.Length - 1, query.Length) 'remove last comma
	query.Append(" FROM ").Append(Main.SelectedTable)
	LoadTableContent(query.ToString, blobColumns.Size > 0)
End Sub
Sub LoadTableContent (Query As String, ContainsBLOB As Boolean)
	Dim h As String
	'If there is a BLOB column then we want to make the table clickable.
	h = DBUtils.ExecuteHtml(Main.SQL, Query _
		, Null, 500, ContainsBLOB)
	WebView1.LoadHtml(h)
End Sub
Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub WebView1_OverrideUrl (Url As String) As Boolean
	    'parse the row and column numbers from the URL
    Dim values() As String
    values = Regex.Split("[.]", URL.SubString(7))
    Dim col, row As Int
    col = values(0)
    row = values(1)
	If blobColumns.ContainsKey(col) Then
		ShowBlobAsImage(col, row)
	End If
    Return True 'Don't try to navigate to this URL
End Sub

Sub ShowBlobAsImage(Col As Int, Row As Int)
	Dim colName As String
	colName = blobColumns.Get(col)
	Dim Cursor As Cursor
	Cursor = Main.SQL.ExecQuery("SELECT " & colName & " FROM " & Main.SelectedTable)
	Cursor.Position = row
	Try
		Dim blob() As Byte
		blob = Cursor.GetBlob2(0)
		If blob.Length = 0 Then
			ToastMessageShow("No bitmap data found.", False)
		Else
			Dim in As InputStream
			in.InitializeFromBytesArray(blob, 0, blob.Length)
			Dim bmp As Bitmap
			bmp.Initialize2(in)
			Image1.Bitmap = bmp
			Image1.Gravity = Gravity.FILL
			Image1.Visible = True
			in.Close
		End If
	Catch
		ToastMessageShow("Error fetching bitmap: " & LastException.Message, True)
	End Try
	Cursor.Close
End Sub
Sub Image1_Click
	Image1.Visible = False
End Sub
Sub Activity_KeyPress (KeyCode As Int) As Boolean 
	If KeyCode = KeyCodes.KEYCODE_BACK AND Image1.Visible = True Then
		'hide the BLOB image instead of closing the activity
		Image1.Visible = False
		Return True
	Else
		Return False
	End If
End Sub
	
