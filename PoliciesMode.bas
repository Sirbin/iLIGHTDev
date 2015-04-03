Type=Activity
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region
'' creare altro campo sulla tabella gruppi conta il numero di address per ogni gruppo''
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	Public m As Map
	m.Initialize
	Public LstDati As List
	Dim timer1 As Timer
	Public StrAddr As List ''' vlista contenete gruppi o anche address
	StrAddr.Initialize
	Public choice As List ' insert the multinput output list
	Public StrAddr1Cancel As List
	StrAddr1Cancel.Initialize
	choice.Initialize
	Public azz As String
			
	Public count As Map ' Map per conteggio address
	'Public cString As String ' conteggio di quante address per gruppo
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	
	Dim lbltitle As Label
	Dim lblCreate As Label
	Private Insert As Button
	Private Delete As Button
	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Groups , set As WheelView
	Private bmp As Bitmap
 	Dim sec As Int
	Private Button1 As Button ' bottone da eliminare
	Private Button2 As Button
	Button2.Initialize("")
	Private Back As Button
	Private GroupsPnl As Panel 'Panello dei dove vengono visualizzate le address delle lampade
	Private lv As ListView
	Private GroupsLabelText As Label
	
	Private GroupsEditPnl As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	
	If FirstTime = True Then
		bmp.Initialize(File.DirAssets, "android48.png")
		'Main.serial1.Initialize("Serial1")
		'Main.serial1.Connect(Main.l.Get(0))
		Activity.LoadLayout("Policies")
		wheel_create(StrAddr)
		Query_SelAddress 'Query for take address
		create_layout
		'Create_Buttom_Generic
		timer1.Initialize("timer1",1000)
		timer1.Enabled = False
	End If 
	'If IsPaused(Main) = True Then 
	CallSub2(Main, "Astreams1_NewData","Buffer")
	'End If
End Sub
Sub Create_Buttom_Generic
	
	Panel2.Initialize("Pannello")
	Activity.AddView(Panel2,500dip,200dip,200dip,450dip)
	Dim color1 As ColorDrawable
	color1.Initialize(Colors.red, 5dip)
	Panel2.Background = color1
	Panel2.AddView(Button2,10,50,50,50)
	
End Sub	
Sub wheel_create ( Stringa As List )
	
	
	
	
	' Create a WhellView , strAddr List are Address with valor ""
	
	Stringa.Initialize	
	Stringa.AddAll(Array As Object (""))
	
	Dim StrSet(2) As String
	StrSet(0) = "yes"
	StrSet(1) = "no"
	
	Dim StrPing(2) As String
	StrPing(0) = "On"
	StrPing(1) = "Off"
	
	Dim StrFollLux(2) As String
	StrFollLux(0) = "FolOn"
	StrFollLux(1) = "FolOff"
	
	Dim StrPresence(2) As String
	StrPresence(0) = "PresOn"
	StrPresence(1) = "PresOff"
	
	Dim StrPresenceValue(2) As String
	StrPresenceValue(0) = "PreLuxHi"
	StrPresenceValue(1) = "PreLuxLo"
	
	Dim StrDelay(3) As String
	StrDelay(0) = "DelayMax"
	StrDelay(1) = "DelayMed"
	StrDelay(2) = "DelayMin"
	
	
	Panel1.Initialize("")
	Dim svsstep As Int 
	svsstep = 50dip
	Groups.Initialize1(svsstep,Stringa,True,"Groups")
	set.Initialize2(svsstep,StrSet,True,"Set")
	Activity.AddView(Groups,50dip,250dip,250dip,svsstep*3)
	Activity.AddView(set,300dip,250dip,80dip,svsstep*3)
	Panel1.SetBackgroundImage(LoadBitmap(File.DirAssets,"cover.png"))
	Activity.AddView(Panel1,50dip,250dip,330dip,svsstep*3)
	DoEvents
End Sub	
'Select the Address to inputmultilist and update a field Groups in table Address , create 
'json string , show all in log
Sub Query_Groups
	
	GroupsLabelText.Text = Groups.ReadWheel 
	Query_AggTable
	For i = 0 To StrAddr.Size -1
		If Groups.ReadWheel = StrAddr.Get(i) AND set.ReadWheel = "yes" Then	
					choice  = InputMultiList( StrAddr1Cancel , "Selection Address")				
					Query_Address ' select query for  Address		
					'l,Query_Create_Json ' select query for json
					'Query_CountAddress ' conteggio delle lampade
						Dim Cursor As Cursor
							Cursor =Main.SQL1.ExecQuery("SELECT * FROM Address")
								For i = 0 To Cursor.RowCount -1
									Cursor.Position = i
										Log(Cursor.GetInt("Key"))
										Log (Cursor.GetString("Address"))
										Log(Cursor.GetString("Groups"))	
										Log(Cursor.GetString("Groups1"))
										Log(Cursor.GetString("Date"))
								Next
							Cursor.Close
				 
					
		End If	
	Next
	
End Sub		
Sub Query_SelAddress
	'Query for Create a list with Address'
	
	Dim Name As String
	Dim Cursor As Cursor
	StrAddr1Cancel.Clear
	Cursor = Main.SQL1.ExecQuery("SELECT Address FROM Address")
		For i = 0 To Cursor.RowCount -1
			Cursor.Position = i
			Name = Cursor.GetString("Address")
			StrAddr1Cancel.Add(Name)
			Log(StrAddr1Cancel)
			'Query_CountAddress		
		Next	
End Sub
Sub Query_Address
''' Creazione dei Gruppi Principali e Secondari

For Each index As Int In choice 	
	If index < StrAddr1Cancel.Size Then
		Dim Cursor1 As Cursor
			Cursor1 = Main.SQL1.ExecQuery2("SELECT Address , Groups , Groups1 FROM Address WHERE Groups = ? and Address = ? or Groups = ? or Groups1 = ? or Groups != ? ",Array As String(Main.groups_default,StrAddr1Cancel.Get(index),Groups.ReadWheel,Main.groups_default,Groups.ReadWheel))
				For i = 0 To Cursor1.RowCount -1		
				Cursor1.Position = i
				Dim oggetto , oggetto1,oggetto2 As Object ' object save the query sql
				oggetto = Cursor1.GetString("Groups")
				oggetto1 = Cursor1.GetString("Groups1")
				oggetto2 = Cursor1.GetString("Address")
				Log(oggetto)
				Log(oggetto1)
				Log(oggetto2)
				Log("Controllo read" & Groups.ReadWheel)
					If oggetto = "Default" AND oggetto2 = StrAddr1Cancel.Get(index) Then
						Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups = ? where Address = ? ",Array As Object(Groups.ReadWheel,StrAddr1Cancel.Get(index))) 
						ToastMessageShow("Insert " & StrAddr1Cancel.Get(index) & " in first Groups " & Groups.ReadWheel ,True)
						Query_AggTable
					Else If oggetto = Groups.ReadWheel OR oggetto1 = Groups.ReadWheel AND oggetto2 = StrAddr1Cancel.Get(index) Then
						ToastMessageShow("Groups " & Groups.ReadWheel & " is  present  to address " & StrAddr1Cancel.Get(index) ,True)											
					Else If oggetto <> Groups.ReadWheel AND oggetto1 = "Default" AND oggetto2 = StrAddr1Cancel.Get(index) Then
						Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups1 = ? where Address = ? ",Array As Object(Groups.ReadWheel,StrAddr1Cancel.Get(index)))
						ToastMessageShow("Insert " & StrAddr1Cancel.Get(index) & " in second Groups " & Groups.ReadWheel ,True)
						Query_AggTable
					Else If oggetto = oggetto AND oggetto1 = oggetto1  AND oggetto2 = StrAddr1Cancel.Get(index) Then
						Dim result As Int
						result = Msgbox2("Groups is not present", "Alert Groups","Second Groups" ,"" , "First Groups",LoadBitmap(File.DirAssets,"idea.png"))
							If result = DialogResponse.POSITIVE Then 
								Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups1 = ? where Address = ? ",Array As Object(Groups.ReadWheel,StrAddr1Cancel.Get(index)))
								Query_AggTable
							Else If result = DialogResponse.NEGATIVE Then 	
								Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups = ? where Address = ? ",Array As Object(Groups.ReadWheel,StrAddr1Cancel.Get(index)))
								Query_AggTable
							End If 	
					End If			
				Next
	End If
	Query_CountAddress ' conteggio address '
Next	
End Sub
	Sub Groups_tick

	Query_Groups
	
	End Sub
	Sub set_tick
	
	Query_Groups
	set.ReadWheel
	
	End Sub
Sub create_layout
	'Create First Label 
	
	lbltitle.Initialize("")
	lbltitle.Text = "iLight Policies Mode"
	lbltitle.TextSize = 34
	lbltitle.Gravity = Gravity.CENTER_HORIZONTAL + Gravity.CENTER_VERTICAL
	lbltitle.TextColor = Colors.RGB(227,227,227)
	Activity.AddView(lbltitle,10dip,10dip,100%x,10%y)
	
	'Create Label Edit Grousp 
		
	Dim LabGroupsEdit As Label	
	
	LabGroupsEdit.Initialize("")
	LabGroupsEdit.Text = "Groups Edit"
	LabGroupsEdit.TextColor = Colors.Blue
	LabGroupsEdit.TextSize = 25
	LabGroupsEdit.Gravity = Gravity.CENTER_HORIZONTAL
	GroupsEditPnl.AddView(LabGroupsEdit,0dip,0dip,150dip,50dip)
	
	'Create Label Address'
	
	Dim LabGroups As Label
	
	LabGroups.Initialize("")
	LabGroups.Text = "Groups"
	LabGroups.TextColor = Colors.RGB(227,227,227)
	LabGroups.TextSize = 25
	LabGroups.Gravity = Gravity.CENTER_HORIZONTAL
	Activity.AddView(LabGroups,50dip,210dip,250dip,50dip)
	
	
	'Create Label Set'
	
	Dim LabSet As Label
	
	LabSet.Initialize("")
	LabSet.Text = "Set"
	LabSet.TextColor = Colors.RGB(227,227,227)
	LabSet.TextSize = 25
	LabSet.Gravity = Gravity.CENTER_HORIZONTAL
	Activity.AddView(LabSet,300dip,210dip,100dip,50dip)
		
	'Create  Panel View Groups'
	
	Dim GroupsLabel,AddressLabel As Label
	Dim sv As ScrollView

	
	sv.Initialize(0)	
	lv.Initialize("")
	GroupsLabel.Initialize("Label")
	AddressLabel.Initialize("Label1")
	GroupsLabelText.Initialize("Label2")
	
	GroupsLabel.Color = Colors.LightGray
	GroupsLabel.TextColor = Colors.Blue
	GroupsLabel.Text = "Groups"
	GroupsLabel.Typeface = Typeface.DEFAULT_BOLD
	GroupsLabel.TextSize = 20
	
	
	
	GroupsLabelText.Color = Colors.Transparent
	GroupsLabelText.TextColor = Colors.Black
	GroupsLabelText.Typeface = Typeface.DEFAULT_BOLD
	GroupsLabelText.TextSize = 18
	
	AddressLabel.Color = Colors.LightGray
	AddressLabel.TextColor = Colors.Blue
	AddressLabel.Typeface = Typeface.DEFAULT_BOLD
	AddressLabel.Text = "Address Lamp"
	AddressLabel.TextSize = 20
	
	lv.AddSingleLine("qualcosa1")
	lv.AddSingleLine("qualcosa2")
	lv.AddSingleLine("qualcosa3")
	lv.AddSingleLine("qualcosa4")
	lv.AddSingleLine("qualcosa5")
	lv.AddSingleLine("qualcosa6")

	GroupsPnl.AddView(GroupsLabel,5dip,5dip,245dip,30dip)
	GroupsPnl.AddView(GroupsLabelText,5dip,40dip,245dip,30dip)
	GroupsPnl.AddView(AddressLabel,5dip,80dip,245dip,30dip)
	GroupsPnl.AddView(sv,5dip,120dip,245dip,240dip)
	GroupsPnl.AddView(lv,5dip,120dip,245dip,240dip)
	
End Sub	
Sub Activity_Resume
	'''Activity Resume'''
	If IsPaused(Main) = True Then 
		CallSub2(Main, "Astreams1_NewData","Buffer")
	End If 	
	bmp.Initialize(File.DirAssets, "android48.png")
	'Main.serial1.Initialize("")
	Activity.LoadLayout("Policies")	
	timer1.Initialize("timer1",1000)
	timer1.Enabled = False
	create_layout

	Dim wer As List
	wer.Initialize
	wheel_create(wer)
	Groups.UpdateList(StrAddr)
	
End Sub 
Sub Query_Create_Json  
	''creation json''
	For Each index As Int In choice
		Dim gen As JSONGenerator
			gen.Initialize(DBUtils.ExecuteJSON(Main.SQL1, "SELECT Key,Address,Groups FROM Address where Address = ?",Array As String (ConfMode.StrAddr1.Get(index)),3,Array As String(DBUtils.DB_INTEGER,DBUtils.DB_TEXT,DBUtils.DB_TEXT)))
			Dim jsonstring As String		
			jsonstring	= jsonstring & gen.ToString
			Log (jsonstring)
	Next	
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub Insert_Click
	''' Insert Groups in list and in table name Groups'''
	
	Dim id As InputDialog
	Dim NameGroups As Object
	id.Input = ""
	NameGroups = id.Input
	id.Hint = "Enter Groups Name!"
	id.HintColor = Colors.ARGB(196, 255, 140, 0)
	Dim resp As Int 
	resp = DialogResponse.POSITIVE
	resp = id.Show("Insert your Name Groups", "Name Groups", "Yes", "No", "", bmp)
	If resp = -1 AND StrAddr.IndexOf("") = 0 Then 
		StrAddr.Clear
		ProgressDialogShow2("Please Wait...",False)
		timer1.Enabled = True
		timer1.Interval = 3000		
		Main.SQL1.ExecNonQuery2("INSERT INTO Groups VALUES(?,?)",Array As Object(Null,id.Input))
		Dim Cursor As Cursor
		Cursor = Main.SQL1.ExecQuery("SELECT Groups FROM Groups")
			For i = 0 To Cursor.RowCount -1
				Cursor.Position = i
				NameGroups = Cursor.GetString("Groups")
				StrAddr.Add(NameGroups)
				Log(Cursor.GetString("Groups"))	
			Next
			Cursor.Close
	Else If  resp = -1 Then
		StrAddr.Clear
		ProgressDialogShow2("Please Wait...",False)
		timer1.Enabled = True
		timer1.Interval = 3000		
		Main.SQL1.ExecNonQuery2("INSERT INTO Groups VALUES(?,?)",Array As Object(Null,id.Input))
		Dim Cursor As Cursor
		Cursor = Main.SQL1.ExecQuery("SELECT Groups FROM Groups")
			For i = 0 To Cursor.RowCount -1
				Cursor.Position = i
				NameGroups = Cursor.GetString("Groups")
				StrAddr.Add(NameGroups)
				Log(Cursor.GetString("Groups"))
			Next
			Cursor.Close
	End If 		
	If resp = -3 Then
	End If
	
End Sub
Sub	timer1_tick
	
	Groups.UpdateList(StrAddr) 	
	ProgressDialogHide
	
End Sub 	
Sub Delete_Click
	'''delete the name groups in list ena d tables'''
	
	For i = 0 To StrAddr.Size -1
		If i < StrAddr.Size Then 
			If Groups.ReadWheel = StrAddr.Get(i) AND set.ReadWheel = "yes" Then
				Main.SQL1.ExecNonQuery2("DELETE FROM Groups where Groups = ?  ",Array As String(Groups.ReadWheel))
				Dim cursor1 As Cursor
 				cursor1 = Main.SQL1.ExecQuery2("SELECT Address,Groups,Groups1 FROM Address WHERE Groups = ? or Groups1 = ?", Array As String(StrAddr.Get(i),StrAddr.Get(i)))
				For j = 0 To cursor1.RowCount -1
					cursor1.Position = j
					Dim oggetto ,oggetto1,oggetto2 As Object
					oggetto = cursor1.GetString("Address")
					oggetto1 = cursor1.GetString("Groups")
					oggetto2 = cursor1.Getstring("Groups1")
					If oggetto1 = Groups.ReadWheel  AND oggetto = oggetto Then
						Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups = ? where Address = ? ",Array As Object(Main.groups_default,oggetto))
					Else If oggetto2 = Groups.ReadWheel AND oggetto = oggetto Then
						Main.SQL1.ExecNonQuery2("UPDATE Address SET Groups1 = ? where Address = ? ",Array As Object(Main.groups_default,oggetto))
					End If 	
					Log ("indirizzo" & cursor1.GetString("Address"))
					Log ("Gruppo" & cursor1.GetString("Groups"))
					Log ("Gruppo1" & cursor1.GetString("Groups1"))
					
				Next	
				'Main.SQL1.ExecNonQuery2("UPDATE Address set Groups = ? or Groups1 = ? where  Groups = ? or Groups1 = ? ",Array As Object( Main.groups_default,StrAddr.Get(i),StrAddr.Get(i)))
			ProgressDialogShow2("Please Wait...",False)
			timer1.Enabled = True
			timer1.Interval = 3000
			StrAddr.RemoveAt(i)
			Query_AggTable ' da controllare
				If StrAddr.Size = 0 Then
					StrAddr.Add("")
					set.SetToValue(0)
				End If
			Log (StrAddr)
			Log ("lunghezza" & StrAddr.Size)
		End If 
	End If 		
	Next	
End Sub
Sub Astreams1_NewData (Buffer() As Byte)
	Dim u As String
	Dim lpos As Long
	Dim rpos As Long
	u = u & BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	Main.str_ = Main.str_ & u 
	Log (Main.str_)
	If Main.str_.Length > 165 Then
		lpos=Main.str_.IndexOf("{")
		rpos=Main.str_.IndexOf2("}",lpos+1)
			If lpos < 0 Then
				Log("lpos negativo ----------------------------------------------")
				Main.str_=" "
			End If		
		If lpos>=0 Then
			If rpos > lpos Then  	
					Main.s = Main.sf.Mid(Main.str_,lpos+1,(rpos+lpos)+1)
						CallSub2(Main,"json_interpreter1","s")	'change the buffef
					Main.str_=Main.sf.Right(Main.str_,(Main.str_.Length-rpos)-1)
			End If
		
		End If 	
	End If
End Sub

Sub Button1_Click
	
	DBUtils.ExecuteListView(Main.SQL1, "SELECT Address, 'Address: ' || Address FROM Address WHERE Groups = ? or Groups1 = ?", _ 
	Array As String (Groups.ReadWheel,Groups.ReadWheel),0,lv,False)
	Query_CountAddress
	'CustomDialog.PanelloGruppi
	''' Da eliminare '''
'	Dim Cursor1 As Cursor 
'	Cursor1 = Main.SQL1.ExecQuery("SELECT * FROM Address")
'	For i = 0  To Cursor1.RowCount -1
'		Cursor1.Position = i
'		Log("chiave" & Cursor1.GetInt("Key"))
'		Log("Indirizzo" & Cursor1.GetString("Address"))
'		Log("Gruppo" & Cursor1.GetString("Groups"))
'		Log ("Gruppo" & Cursor1.GetString("Groups1"))
'		Log("Data" & Cursor1.GetString("Date"))
'	Next
'	Dim cursor2 As Cursor
'	cursor2 = Main.SQL1.ExecQuery("SELECT * FROM Groups")
'	For i = 0  To cursor2.RowCount -1
'		cursor2.Position = i
'		Log("chiave" & cursor2.GetInt("Key"))
'		Log("Gruppo" & cursor2.GetString("Groups"))
'	Next
	
End Sub
Sub Back_Click
	
	Activity.Finish
	StartActivity("main")
	
End Sub
Sub ControllGroups	
'	For i = 0 To StrAddr.Size -1
'		DBUtils.ExecuteSpinner(Main.SQL1,"SELECT Groups ,Groups1 FROM Address",Null,0,SprinGroups)
'	Next
'	SprinGroups_ItemClick(0,SprinGroups.GetItem(0)
'	For i = 0 To StrAddr.Size -1
'		SprinGroups.AddAll(Array As String(StrAddr.Get(i)))
'	Next	
'	Activity.AddView(SprinGroups,400dip,50dip,100dip,30dip)
'		Dim pnl1,pnl2 As Panel
'		
'		Dim TableGruppi As Table
'		pnl1.Initialize("PnlGruppi")
'		Dim lv As ListView
'		lv.Initialize("")

'	Dim m As Map
'	m = DBUtils.ExecuteMap(Main.SQL1,"SELECT Address, Groups ,Groups1 FROM Address where  = ?, array as 
'	DBUtils.
'	DBUtils..ExecuteListView(Main.SQL1, "SELECT Groups , Groups1 FROM Address where Address = ? ", Array As String("0x0013a20040be447f"), 0 ,lv, True)
	
	
'	TableGruppi.Initialize(Me,"TableGroups",4,Gravity.CENTER_HORIZONTAL,True)
'	TableGruppi.AddToActivity(pnl1 , 0, 0, 100%x,100%y)	
'    TableGruppi.SetHeader(Array As String(
'	GroupsPnl.Initialize("")
'	Dim bg,bg1 As ColorDrawable
'	bg.Initialize(Colors.White,2dip)
'	bg1.Initialize(Colors.Green,2dip)
''	Dim ch,ch1 As CheckBox
''	ch.Initialize("Pulsanteall")
''	ch1.Initialize("")
''	ch.Text = "all"
'		
'	pnl2.Initialize("Pnl2")
'	pnl2.Background = bg1
'	'GroupsPnl.AddView(AddrLabel,100dip,100dip,50dip,20dip)
'	'Activity.AddView(pnl1,430,60,250,550)
''	Dim Labell As Label
''	Labell.Initialize("")
''	Labell.Text = "Seleziona"
''	Labell.Color = Colors.Black
End Sub
Sub Query_AggTable
	' Aggiorna la tabella con le nuove address'
	
	DBUtils.ExecuteListView(Main.SQL1, "SELECT Address, 'Address: ' || Address FROM Address WHERE Groups = ? or Groups1 = ?", _ 
	Array As String (Groups.ReadWheel,Groups.ReadWheel),0,lv,False)
	
End Sub
Sub Query_CountAddress
		For i = 0 To StrAddr.Size -1
	 		count = DBUtils.ExecuteMap(Main.SQL1, "SELECT COUNT(Address) FROM Address WHERE Groups = ? or Groups1 = ?",Array As String(StrAddr.Get(i),StrAddr.Get(i)))
			For Each cString As String In count.Values
				azz = (cString)
				Log ("numero" & azz)
			Next	
		Next	
End Sub 	