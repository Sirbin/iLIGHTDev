Type=StaticCode
Version=3.82
B4A=true
@EndOfDesignText@
Sub Globals
	Dim SV As ScrollView
	Dim Header As Panel
	Dim Table As Panel
	Dim NumberOfColumns, RowHeight, ColumnWidth As Int
	Dim HeaderColor, TableColor, FontColor, HeaderFontColor As Int
	Dim FontSize As Float
	Type RowCol (Row As Int, Col As Int)
	Dim Alignment As Int
	Dim SelectedRow As Int
	Dim SelectedRowColor As Int
	
	'Table settings
	HeaderColor = Colors.Gray
	NumberOfColumns = 4
	RowHeight = 30dip
	TableColor = Colors.White
	FontColor = Colors.Black
	HeaderFontColor = Colors.White
	FontSize = 14
	Alignment = Gravity.CENTER 'change to Gravity.LEFT or Gravity.RIGHT for other alignments.
	SelectedRowColor = Colors.Blue
End Sub

Sub Activity_Create(FirstTime As Boolean)
	SV.Initialize(0)
	Table = SV.Panel
	Table.Color = TableColor
	Activity.AddView(SV, 5%x, 10%y, 90%x, 80%y)
	ColumnWidth = SV.Width / NumberOfColumns
	SelectedRow = -1
	'add header
	SetHeader(Array As String("Node1", "Node2", "Node3", "Node4", "Node5", "Node6"))
	'add rows
	AddRow(Array As String())
	Next
	'set the value of a specific cell
	SetCell(0, 3, "New value")
	'get the value 
	Log("Cell (1, 2) value = " & GetCell(1, 2))
End Sub

Sub Cell_Click
	Dim rc As RowCol
	Dim l As Label
	l = Sender
	rc = l.Tag
	SelectRow(rc.Row)
	Activity.Title = "Cell clicked: (" & rc.Row & ", " & rc.Col & ")"
End Sub
Sub Header_Click
	Dim l As Label
	Dim col As Int
	l = Sender
	col = l.Tag
	Activity.Title = "Header clicked: " & col
End Sub
Sub SelectRow(Row As Int)
	'remove the color of previously selected row
	If SelectedRow > -1 Then
		For col = 0 To NumberOfColumns - 1
			GetView(SelectedRow, col).Color = Colors.Transparent
		Next
	End If
	SelectedRow = Row
	For col = 0 To NumberOfColumns - 1
		GetView(Row, col).Color = SelectedRowColor
	Next
End Sub
Sub GetView(Row As Int, Col As Int) As Label
	Dim l As Label
	l = Table.GetView(Row * NumberOfColumns + Col)
	Return l
End Sub
Sub AddRow(Values() As String)
	If Values.Length <> NumberOfColumns Then
		Log("Wrong number of values.")
		Return
	End If
	Dim lastRow As Int
	lastRow = NumberOfRows
	For i = 0 To NumberOfColumns - 1
		Dim l As Label
		l.Initialize("cell")
		l.Text = Values(i)
		l.Gravity = Alignment
		l.TextSize = FontSize
		l.TextColor = FontColor
		Dim rc As RowCol
		rc.Initialize
		rc.Col = i
		rc.Row = lastRow
		l.Tag = rc
		Table.AddView(l, ColumnWidth * i, RowHeight * lastRow, ColumnWidth, RowHeight)
	Next
	Table.Height = NumberOfRows * RowHeight
End Sub
Sub SetHeader(Values() As String)
	If Header.IsInitialized Then Return 'should only be called once
	Header.Initialize("")
	For i = 0 To NumberOfColumns - 1
		Dim l As Label
		l.Initialize("header")
		l.Text = Values(i)
		l.Gravity = Gravity.CENTER
		l.TextSize = FontSize
		l.Color = HeaderColor
		l.TextColor = HeaderFontColor
		l.Tag = i
		Header.AddView(l, ColumnWidth * i, 0, ColumnWidth, RowHeight)
	Next
	Activity.AddView(Header, SV.Left, SV.Top - RowHeight, SV.Width, RowHeight)
End Sub
Sub NumberOfRows As Int
	Return Table.NumberOfViews / NumberOfColumns
End Sub

Sub SetCell(Row As Int, Col As Int, Value As String)
	GetView(Row, Col).Text = Value
End Sub
Sub GetCell(Row As Int, Col As Int) As String
	Return GetView(Row, Col).Text
End Sub
Sub ClearAll
	For i = Table.NumberOfViews -1 To 0 Step -1
		Table.RemoveViewAt(i)
	Next
	Table.Height = 0
	SelectedRow = -1
End Sub
Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
