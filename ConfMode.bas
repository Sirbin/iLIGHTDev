Type=Activity
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
   	
	Dim Timer1,Timer2 ,Timer3 As Timer
	Dim timercoll,TimerStopPwm,TimerStopPresence As Timer
	Public StrAddrPwm(10) As Int
	Public StrAddr1 As List ''' Prova si stringhe gia inserite
	StrAddr1.Initialize2(Array As String ("0x0013a20040be447f","0x0013a200406ff46e","0x0013a20040332051","0x0013a20040626109"))
	Public StrAddr(4) As String
	Public add(4) As String ' provvisoria
	Public sec,count As Int 
	Public admin As BluetoothAdmin
	Public serial1 As Serial
	Public json As JSONParser
	Public map1 As Map
	Public invio_dati As String 
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	
	Dim Addres,Set,choice,FollowLux, FollowLuxOn_Off , PresenceOn_OFF , PresenceHi_LOW ,DelayOn_Off As WheelView
	Dim pwm_to_timer0 ,pwm_to_timer1,pwm_to_timer2,pwm_to_timer3 ,pwm_Pre0,pwm_Pre1,pwm_Pre2,pwm_Pre3 ,pwm_Foll0,pwm_Foll1,pwm_Foll2,pwm_Foll3 As Int 
	Public Address As ListView
	Public GoNext1 As Button
	Public GoBack2 As Button
	Public GoBack1 As Button
	Public Finish1 As Button
	Dim Panel1 As Panel
	Public Label1 As Label
	Dim l As List 
	l.Initialize 
	Dim str_,s As String
	Private lblFont As Typeface
	Private lblLuxValue As Label
	Private Circle,Circle1,Circle2 As CircleSeek
	Dim arr(5) As Int
	Private SetAddress As ToggleButton
	Private SetGroups As Button
	Dim Pwmvalue , PresenceHiLowvalue As Int ' valore del pwm generale per gruppi '
	
	Dim LabAddress As Label
	Dim astreams1 As AsyncStreams
	Dim sf As StringFunctions
   	sf.Initialize

End Sub

Sub Activity_Create(FirstTime As Boolean)

	If FirstTime Then 		
		admin.Initialize("BT")
		serial1.Initialize("Serial1")
		Activity.LoadLayout("ConfigurationWizard")
		Label_create
		wheel_create
		Circle.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
		Circle1.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
		Circle2.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
   	End If 
	Timer1.Initialize("Timer1",1000)
	Timer1.Enabled = True
	Timer2.Initialize("Timer2",1000)
	Timer2.Enabled = True
	Timer3.Initialize("Timer3",1000)
	Timer3.Enabled = True
	TimerStopPwm.Initialize("TimerStopPwm",1000)
	TimerStopPresence.Initialize("TimerStopPresence",1000)
	If admin.IsEnabled = False Then
		admin.Enable 
		Log("Bt is ready") 	
	End If
	 
	
End Sub
Sub Activity_Resume

    Log("this is activity resume")	 	
	If Circle.IsInitialized = False OR Circle1.IsInitialized = False OR Circle2.IsInitialized = False Then
		Activity.LoadLayout("configurationwizard")
		Label_create
		wheel_create
		Circle.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
		Circle1.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
		Circle2.setColors(Colors.RGB(150,150,255), Colors.RGB(50,205,50), Colors.RGB(227,227,227), Colors.Yellow, 24*Size.cf)
		Circle.Value = 0
		Circle1.Value = 0
		Circle2.Value = 0
	End If 
	Circle.Value = 0	
	Circle1.Value = 0
	Circle2.Value = 0
	If Timer1.Enabled = False OR Timer2.Enabled = False OR Timer3.Enabled = False Then
		Timer1.Enabled = True
		Timer2.Enabled = True
		Timer3.Enabled = True
	End If 
	If admin.IsEnabled = False Then
 		admin.Enable
	End If 	
	 	
	
End Sub		
Sub Label_create
	'Create all Label for ReadWheal'
	
	Dim LabSet As Label
	Dim LabPing As Label
	Dim LabDelay As Label
	Dim LabPresenceOn_Off As Label
	Dim LabPresenceHi_Low As Label
	Dim LabFollowLux As Label
	LabAddress.Initialize("")
	LabSet.Initialize("")
	LabPing.Initialize("")
	LabDelay.Initialize("")
	LabPresenceOn_Off.Initialize("")
	LabPresenceHi_Low.Initialize("")
	LabFollowLux.Initialize("")
	LabAddress.Text = "Address"
	LabAddress.TextColor = Colors.RGB(227,227,227)
	LabAddress.TextSize = 25
	LabAddress.Gravity = Gravity.CENTER_HORIZONTAL
	LabSet.Text = "Set"
	LabSet.TextColor = Colors.RGB(227,227,227)
	LabSet.TextSize = 25
	LabSet.Gravity = Gravity.CENTER_HORIZONTAL
	LabPing.Text = "Ping"
	LabPing.TextColor = Colors.RGB(227,227,227)
	LabPing.TextSize = 25
	LabPing.Gravity = Gravity.CENTER_HORIZONTAL
	LabDelay.Text = "Delay"
	LabDelay.TextColor = Colors.RGB(227,227,227)
	LabDelay.TextSize = 25
	LabDelay.Gravity = Gravity.CENTER_HORIZONTAL
	LabPresenceOn_Off.Text = "Presen"
	LabPresenceOn_Off.TextColor = Colors.RGB(227,227,227)
	LabPresenceOn_Off.TextSize = 25
	LabPresenceOn_Off.Gravity = Gravity.CENTER_HORIZONTAL
	LabPresenceHi_Low.Text = "PresH_L"
	LabPresenceHi_Low.TextColor = Colors.RGB(227,227,227)
	LabPresenceHi_Low.TextSize = 25
	LabPresenceHi_Low.Gravity = Gravity.CENTER_HORIZONTAL
	LabFollowLux.Text = "FollLux"
	LabFollowLux.TextColor = Colors.RGB(227,227,227)
	LabFollowLux.TextSize = 25
	LabFollowLux.Gravity = Gravity.CENTER_HORIZONTAL
	Activity.AddView(LabAddress,50dip,85dip,250dip,50dip)
	Activity.AddView(LabSet,300dip,85dip,80dip,50dip)
	Activity.AddView(LabPing,380dip,85dip,80dip,50dip)
	Activity.AddView(LabDelay,460dip,85dip,130dip,50dip)
	Activity.AddView(LabPresenceOn_Off,590dip,85dip,130dip,50dip)
	Activity.AddView(LabPresenceHi_Low,720dip,85dip,130dip,50dip)
	Activity.AddView(LabFollowLux,850dip,85dip,130dip,50dip)
	
End Sub

Sub wheel_create	
	'StrAddr1.Initialize2(Array As String ("0x0013a20040be447f","0x0013a200406ff46e","0x0013a20040332051","0x0013a20040626109"))
	Log(StrAddr1)
	
	StrAddr(0) = "0x0013a20040be447f"
	StrAddr(1) = "0x0013a200406ff46e"
	StrAddr(2) = "0x0013a20040332051"
	StrAddr(3) = "0x0013a20040626109"
	
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
	Addres.Initialize1(svsstep,StrAddr1,True,"Addres")
	Set.Initialize2(svsstep,StrSet,True,"Set")
	choice.Initialize2(svsstep,StrPing,True,"choice")
	DelayOn_Off.Initialize2(svsstep,StrDelay,True,"DelayOn_Off")
	FollowLux.Initialize(svsstep,1,100,True,"FollowLux")
	FollowLuxOn_Off.Initialize2(svsstep,StrFollLux,True,"FollowLuxOn_Off")
	PresenceOn_OFF.Initialize2(svsstep,StrPresence,True,"PresenceOn_Off")
	PresenceHi_LOW.Initialize2(svsstep,StrPresenceValue,True,"PresenceHi_Low")
	Activity.AddView(Addres,50dip,125dip,250dip,svsstep*3)
	Activity.AddView(Set,300dip,125dip,80dip,svsstep*3)
	Activity.AddView(choice,380dip,125dip,80dip,svsstep*3)
	Activity.AddView(DelayOn_Off,460dip,125dip,130dip,svsstep*3)
	Activity.AddView(PresenceOn_OFF,590dip,125dip,130dip,svsstep*3)
	Activity.AddView(PresenceHi_LOW,720dip,125dip,130dip,svsstep*3)
	Activity.AddView(FollowLuxOn_Off,850,125dip,130dip,svsstep*3)
	Panel1.SetBackgroundImage(LoadBitmap(File.DirAssets,"cover.png"))
	Activity.AddView(Panel1,50dip,125,930dip,svsstep*3)
	DoEvents
	
End Sub 	
Sub Activity_Pause (UserClosed As Boolean)
End Sub
Sub init_label
	Label1.Initialize("")
	Label1.TextSize = 50
	Label1.Gravity = Gravity.CENTER_HORIZONTAL
	Activity.AddView(Label1,100dip,100dip,150dip,40dip)
End Sub
Sub Astreams1_NewData (Buffer() As Byte)

	Dim u As String
	Dim lpos As Long
	Dim rpos As Long
	u = u & BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	str_ = str_ & u 
	If str_.Length > 180 Then
		lpos= str_.IndexOf("{")
		rpos= str_.IndexOf2("}",lpos+1)
		If lpos < 0 Then
			Log("lpos negativo ----------------------------------------------")
			str_=" "
		End If		
		If lpos>=0 Then
			If rpos > lpos Then  	
						s = sf.Mid(str_,lpos+1,(rpos+lpos)+1)
							json_interpreter1(s)	'change the buffer'
							str_= sf.Right(str_,(str_.Length-rpos)-1) 
			End If
		
		End If 	
	End If
End Sub

Sub json_interpreter1 (jstr As String)
	' Create a json map and controll the type of "pktype" if it's "hello" add in lstaddr'
	'if "reply" controll the command and save in string, if "sensors take a date"
	
	Try 
	json.Initialize(jstr)
	map1.Initialize
	map1= json.NextObject
'	If 	map1.Get("pktype") = "hello" Then 
'		Main.lstaddr.add(map1.Get("address64"))
'		Log (Main.lstaddr)
	 If map1.Get("pktype") = "reply" Then
		If map1.Get("command") =  "3" Then
			arr = map1.Get("value")
		Else If map1.Get("command") = "1" Then
			arr = map1.Get("value")
		Else If map1.Get("command") = "2" Then
			arr = map1.Get("value") 	
		Else If map1.Get("command") = "4" Then
			arr(1) = map1.Get("value")
		Else If map1.Get("command") = 10 Then
			arr(1) = map1.Get("value")
		Else If map1.Get("command") = 11 Then
			arr(2) = map1.Get("value")
		Else If map1.Get("command") = 5 Then 
			arr(3) = map1.Get("value")
		Else If map1.Get("pktype") = "sensors" Then
		End If 
	Else If map1.Get("pktype") = "sensors" Then 	
		Take_Address_Take_Pwm
	End If  	
	Catch
		admin.Disable 
		timercoll.Initialize("TimerColl", 1000)
		timercoll.Enabled = True
	End Try	
End Sub 	
Sub TimerColl_tick
	'When Bt Disable TimerColl try to connect to Bt every 5 sec'
	
	sec = sec + 1
	If sec > 5 Then 
			admin.Enable
			BT_StateChanged(1,0)
				If admin.Enable = True Then
					timercoll.Enabled = False
				End If			
	End If 
	TimerStopPwm.Enabled = False ' case the Bt Down
	TimerStopPresence.Enabled = False 
End Sub	
Sub Take_Address_Take_Pwm 
' Pwm Valor of Address and save in string, need when compare with real pwm'

		If map1.Get("address64") = "0x0013a20040be447f" Then
				StrAddrPwm(4) = map1.Get("pwm") 
		Else If map1.Get("address64") = "0x0013a200406ff46e" Then 
				StrAddrPwm(5) = map1.Get("pwm")
		Else If map1.Get("address64") = "0x0013a20040332051" Then
				StrAddrPwm(6) = map1.Get("pwm")
		Else If map1.Get("address64") = "0x0013a20040626109" Then 
				StrAddrPwm(7) = map1.Get("pwm")
		End If	
		
	End Sub 	
Sub BT_StateChanged(NewState As Int,OldState As Int)
	' connect to 3box '
	
	If NewState = admin.STATE_ON Then
		Connect_3box
		Log("BT Connect")
	Else 
		serial1.Disconnect 
		Log("BT Disconnect")
	End If
	
End Sub
Sub Serial1_Connected (success As Boolean)
' connect to serial Bt and ready to send the astream'


	Try 
	If success = True Then
		ToastMessageShow("Bluetooth connect with success" ,True)
		ToastMessageShow("Bluetooth connected to " & l.Get(0),False)				
		astreams1.Initialize(serial1.InputStream,serial1.OutputStream,"AStreams1")
	Else	
		ToastMessageShow("Connection to " & l.Get(0) & "broken!",True)
	End If
	Catch
		Return 
	End Try	
	
End Sub
Sub Connect_3box 
' add 3box in list and connect with it'

	Public PariredDevices As Map
	Dim MyDevice As String
	MyDevice = "3box"
	PariredDevices = serial1.GetPairedDevices		
	If PariredDevices.ContainsKey(MyDevice) Then 
		l.add(PariredDevices.Get(MyDevice))
		Log(l)
	End If 
	serial1.Connect(l.Get(0))
	
End Sub	
Sub Addres_tick
	If Addres.ReadWheel = StrAddr(0) Then
		Circle.Value = pwm_to_timer0
	Else If Addres.ReadWheel = StrAddr(1) Then	
		Circle.Value = pwm_to_timer1
	Else If Addres.ReadWheel = StrAddr(2) Then
		Circle.Value = pwm_to_timer2
	Else If Addres.ReadWheel = StrAddr(3) Then
		Circle.Value = pwm_to_timer3
	End If

End Sub 	
Sub string_invPing(cmd As Int ,Addr As String)
	'create type string'
	
	astreams1.Write(invio_dati.GetBytes("UTF-8"))
	Select cmd
	Case 1
		invio_dati = "1," & Addr & ";"
		Log ("pingon" &invio_dati)
	Case 2 
		invio_dati = "2," & Addr & ";"
		Log ("pingoff" &invio_dati)
	Case 6
		invio_dati = "6," & Addr & ";"
		Log ("Follow On " & invio_dati)
	Case 7
		invio_dati = "7," & Addr & ";"
		Log ("Follw Off " & invio_dati)
	Case 8
		invio_dati = "8," & Addr & ";"
		Log ("Presence On" & invio_dati)
	Case 9
		invio_dati = "9," & Addr & ";"
		Log ("Presence Off" & invio_dati)
	End Select
End Sub	
Sub string_inv(cmd As Int, Addr As String, value As Int )
	'creare a second type string add a value takes to circle'
	
	astreams1.Write(invio_dati.GetBytes("UTF-8"))	
	If cmd = 3 Then 				' Set Light Value
		invio_dati = "3," & Addr & "," & value & ";"
		Log ("Pwm" & invio_dati)
	Else If  cmd = 4 Then 				'Set Delay value (0 = Fast , 20 = Slow)
		invio_dati = "4," & Addr & "," & value & ";"
		Log ("Delay" & invio_dati)
	Else If cmd = 5 Then 			' Set FollowLux Value
		invio_dati = "5," & Addr & "," & value & ";"
		Log ("Foll value " & invio_dati)
	Else If cmd = 10 Then 			' Set Presence High Value
		invio_dati = "10," & Addr & "," & value & ";"
		Log ("Presence Hi" & invio_dati)
	Else If cmd = 11 Then 			' Set Presence Low Value
		invio_dati = "11," & Addr & "," & value & ";"
		Log ("Presence Low" & invio_dati)	
	End If
	
End Sub 	
Sub GoBack1_Click
	'Button to return in Main Page'
	
    If admin.IsEnabled = True Then 
		admin.disable
		Log("Bt as Disable")
	End If 
	Activity.Finish
	l.Clear
	StartActivity("main")
	
End Sub
Sub Circle_ValueChanged(value As Int,UserChanged As Boolean)
	
	'circle value for pwn, if choice Groups stop timer1 and userchange set to false and read the value'
	' the value is always Pwmvalue for all grousp , after start a timerstop that every 10 second controll'
	' a value.'
	' second types are based to single address'
	
	For index = 0 To PoliciesMode.StrAddr.Size	-1
		If UserChanged = True  AND Addres.ReadWheel = PoliciesMode.StrAddr.Get(index) AND Set.ReadWheel = "yes" Then
				Timer1.Enabled = False
				UserChanged = False 
				If UserChanged = False Then
					TimerStopPwm.Initialize("TimerStopPwm",1000)
					TimerStopPwm.Enabled = True
					Pwmvalue = value
					Log ("Valore finale" & Pwmvalue)
				End If				
		End If
	Next	
	If UserChanged  AND Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" Then
		If Timer1.Enabled = False Then 
			Timer1.Enabled = True
		End If 	
			pwm_to_timer0 = value
	End If 
	If UserChanged AND Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" Then
		If Timer1.Enabled = False Then 
			Timer1.Enabled = True
		End If 
		pwm_to_timer1 = value
	End If
	If UserChanged AND Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" Then
		If Timer1.Enabled = False Then 
			Timer1.Enabled = True
		End If 
		pwm_to_timer2 = value
	End If
	If UserChanged AND  Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" Then 
		If Timer1.Enabled = False Then 
			Timer1.Enabled = True
		End If 
		pwm_to_timer3 = value
	End If 

End Sub
Sub TimerstopPwm_tick
	'new'
	'the timer that controll the value and send the right string_inv ground on numenb of sql address'
	'connect to Circle Value'
	
	sec = sec + 1
	Log ("Timer1 Gruppo CirclePwm" & sec)		
	Do While sec = 10 
		For i = 0 To PoliciesMode.StrAddr.Size -1
			If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" Then
				Dim cursor1 As Cursor
				cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String ' object save the query sql
		    			Adrquery = cursor1.GetString("Address")
						Log("verificare quale address esce" & Adrquery)
						string_inv(3,Adrquery,Pwmvalue)
						string_inv(3,Adrquery,Pwmvalue)
					Next
			End If 		
		Next			
		sec = 0
		TimerStopPwm.Enabled = False
	Loop	
	
End Sub
Sub Circle1_ValueChanged(value As Int,UserChanged As Boolean)
	
	' Circle to presence need modify for Groups'
	
	' Groups Value'
	
	For index = 0 To PoliciesMode.StrAddr.Size	-1
		If UserChanged = True  AND Addres.ReadWheel = PoliciesMode.StrAddr.Get(index) AND Set.ReadWheel = "yes"  Then
				Timer1.Enabled = False
				Timer2.Enabled = False
				UserChanged = False 
				If UserChanged = False Then
					TimerStopPresence.Initialize("TimerStopPresence",1000)
					TimerStopPresence.Enabled = True
					PresenceHiLowvalue = value
					Log ("Valore finale" & Pwmvalue)
				End If				
		End If
	Next
	
	'Single Value'
	
	If UserChanged AND	Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" Then
		pwm_Pre0 = value
		If Timer2.Enabled = False Then 
			Timer2.Enabled = True
		End If 	
	End If 	  
	If UserChanged AND Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" Then 
		pwm_Pre1 = value
		If Timer2.Enabled = False Then 
			Timer2.Enabled = True
		End If 	
	End If
	If UserChanged AND Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" Then
		pwm_Pre2 = value
		If Timer2.Enabled = False Then 
			Timer2.Enabled = True
		End If 	
	End If
	If UserChanged AND  Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" Then 
		pwm_Pre3 = value
		If Timer2.Enabled = False Then 
			Timer2.Enabled = True
		End If 	
	End If 
	
End Sub
Sub TimerstopPresence_tick
	
	sec = sec + 1
	Log ("Timer1 Gruppo CirclePresence" & sec)		
	Do While sec = 10 
		For i = 0 To PoliciesMode.StrAddr.Size -1
			If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxHi" Then
				Dim cursor1 As Cursor
				cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String ' object save the query sql
		    			Adrquery = cursor1.GetString("Address")
						Log("verificare quale address esce" & Adrquery)
						string_inv(10,Adrquery,PresenceHiLowvalue)
						string_inv(10,Adrquery,PresenceHiLowvalue)
					Next
			End If
		Next			
		sec = 0
		TimerStopPresence.Enabled = False
	Loop	
	
End Sub
Sub Circle2_ValueChanged(value As Int ,UserChanged As Boolean)

	'circle for follow need modify for Groups
	
		If Timer3.Enabled = False Then 
			Timer3.Enabled = True
		End If 	
		pwm_Foll3 = value
		Log ("timer3" & pwm_Foll3)	
		
End Sub 
Sub Timer3_tick

	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
					string_inv(5,StrAddr(0),pwm_Foll3)
					count = count + 1 
					Log ("secondi" & count)
				If count = 3 Then
					Timer3.Enabled = False
					count = 0
					Log ("addr0" & pwm_to_timer0)
				End If 
	End If
	If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
					string_inv(5,StrAddr(1),pwm_Foll3)
					count = count + 1 
					Log ("secondi" & count)
				If count = 3 Then
					Timer3.Enabled = False
					count = 0
				End If 
	End If
	If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
					string_inv(5,StrAddr(2),pwm_Foll3)
					count = count + 1 
					Log ("secondi" & count)
				If count = 3 Then
					Timer3.Enabled = False
					count = 0
				End If 
	End If
	If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
					string_inv(5,StrAddr(3),pwm_Foll3)
					count = count + 1 
					Log ("secondi" & count)
				If count = 3 Then
					Timer3.Enabled = False
					count = 0
				End If 
	End If
End Sub
Sub daeliminare
'	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND foll.ReadWheel = "PreLuxHi" Then
'		If arr(1) <> pwm_Pre1 Then
'			string_inv(10,StrAddr(1),pwm_Pre1)
'		Else If arr(1) = pwm_Pre1 Then
'			Timer2.Enabled = False
'			Log ("valori uguali")
'		End If 
'	Else If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxLo" Then
'		If arr(2) <> pwm_Pre1 Then
'			string_inv(11,StrAddr(1),pwm_Pre1)
'		Else If arr(2) = pwm_Pre1 Then
'			Timer2.Enabled = False
'			Log ("valori uguali")
'		End If 	
'	End If
End Sub
Sub PresenceHi_LOW_tick

	PresenceHi_LOW.ReadWheel
	
End Sub
Sub Timer2_tick

	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxHi" Then
		If arr(1) <> pwm_Pre0 Then
			string_inv(10,StrAddr(0),pwm_Pre0)
		Else If arr(1) = pwm_Pre0 Then
			Timer2.Enabled = False
			Log ("valori uguali0")
		End If 
	Else If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxLo" Then
		If arr(2) <> pwm_Pre0 Then
			string_inv(11,StrAddr(0),pwm_Pre0)
		Else If arr(2) = pwm_Pre0 Then
			Timer2.Enabled = False
			Log ("valori uguali1")
		End If 	
	End If
	If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxHi" Then
		If arr(1) <> pwm_Pre1 Then
			string_inv(10,StrAddr(1),pwm_Pre1)
		Else If arr(1) = pwm_Pre1 Then
			Timer2.Enabled = False
			Log ("valori uguali2")
		End If 
	Else If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxLo" Then
		If arr(2) <> pwm_Pre1 Then
			string_inv(11,StrAddr(1),pwm_Pre1)
		Else If arr(2) = pwm_Pre1 Then
			Timer2.Enabled = False
			Log ("valori uguali3")
		End If 	
	End If
	If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxHi" Then
		If arr(1) <> pwm_Pre2 Then
			string_inv(10,StrAddr(2),pwm_Pre2)
		Else If arr(1) = pwm_Pre2 Then
			Timer2.Enabled = False
			Log ("valori uguali")
		End If 
	Else If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxLo" Then
		If arr(2) <> pwm_Pre2 Then
			string_inv(11,StrAddr(2),pwm_Pre2)
		Else If arr(2) = pwm_Pre2 Then
			Timer2.Enabled = False
			Log ("valori uguali")
		End If 	
	End If
	If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxHi" Then
		If arr(1) <> pwm_Pre3 Then
			string_inv(10,StrAddr(3),pwm_Pre3)
		Else If arr(1) = pwm_Pre3 Then
			Timer2.Enabled = False
			Log ("valori uguali")
		End If 
	Else If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND PresenceHi_LOW.ReadWheel = "PreLuxLo" Then
		If arr(2) <> pwm_Pre3 Then
			string_inv(11,StrAddr(3),pwm_Pre3)
		Else If arr(2) = pwm_Pre3 Then
			Timer2.Enabled = False
			Log ("valori uguali")
		End If 	
	End If
	
End Sub 
	
Sub PresenceOn_OFF_tick

	presenceOnOff
End Sub 

Sub presenceOnOff
	'Set Presence Single Lamp and Groups Lamp'
	
	'Groups Presence'
	
	For i = 0 To PoliciesMode.StrAddr.Size -1
		If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND PresenceOn_OFF.ReadWheel = "PresOn" Then
		Dim cursor1 As Cursor
			cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String 
		    			Adrquery = cursor1.GetString("Address")
						string_invPing(8,Adrquery)
						string_invPing(8,Adrquery)
					Next		
		Else If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND PresenceOn_OFF.ReadWheel = "PresOff" Then
		Dim cursor2	As Cursor
			cursor2 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor2.RowCount -1		
						cursor2.Position = i
		    			Adrquery = cursor2.GetString("Address")
						string_invPing(9,Adrquery)
						string_invPing(9,Adrquery)
					Next
		End If
	Next
	
	'Single Presence'
	
	If Addres.ReadWheel = StrAddr(0) AND PresenceOn_OFF.ReadWheel = "PresOn" AND Set.ReadWheel = "yes" Then
		string_invPing(8,StrAddr(0))
		Timer1.Enabled = False
	Else If Addres.ReadWheel = StrAddr(0) AND PresenceOn_OFF.ReadWheel = "PresOff" Then
		string_invPing(9,StrAddr(0))
		string_invPing(9,StrAddr(0))
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(1) AND PresenceOn_OFF.ReadWheel = "PresOn" AND Set.ReadWheel = "yes" Then
		string_invPing(8,StrAddr(1))
		Timer1.Enabled = False
	Else If Addres.ReadWheel = StrAddr(1) AND PresenceOn_OFF.ReadWheel = "PresOff" Then
		string_invPing(9,StrAddr(1))
		string_invPing(9,StrAddr(1))
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(2) AND PresenceOn_OFF.ReadWheel = "PresOn" AND Set.ReadWheel = "yes" Then
		string_invPing(8,StrAddr(2))
		Timer1.Enabled = False
	Else If Addres.ReadWheel = StrAddr(2) AND PresenceOn_OFF.ReadWheel = "PresOff" Then
		string_invPing(9,StrAddr(2))
		string_invPing(9,StrAddr(2))
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(3) AND PresenceOn_OFF.ReadWheel = "PresOn" AND Set.ReadWheel = "yes" Then
		string_invPing(8,StrAddr(3))
		Timer1.Enabled = False
	Else If Addres.ReadWheel = StrAddr(3) AND PresenceOn_OFF.ReadWheel = "PresOff" Then
		string_invPing(9,StrAddr(3))
		string_invPing(9,StrAddr(3))
		Timer1.Enabled = False
	End If 
	
End Sub	
Sub choice_tick
	SetPingOn_Off
End Sub	
Sub SetPingOn_Off
	
	'set Ping on Groups and single Address"
	
	'Groups Lamp'
	
	For i = 0 To PoliciesMode.StrAddr.Size -1 
			If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND choice.ReadWheel = "On" Then
				Dim cursor1 As Cursor
				cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String 
		    			Adrquery = cursor1.GetString("Address")
						string_invPing(1,Adrquery)
						string_invPing(1,Adrquery)
					Next
			Else If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND choice.ReadWheel = "Off" Then
				Dim cursor1 As Cursor
				cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String 
		    			Adrquery = cursor1.GetString("Address")
						string_invPing(2,Adrquery)
						string_invPing(2,Adrquery)
					Next
			End If	
	Next
	
	'Single Lamp'
	
	If Addres.ReadWheel = StrAddr(0) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(0))
	Else If Addres.ReadWheel = StrAddr(0) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing(2,StrAddr(0))
		string_invPing(2,StrAddr(0))
		Timer1.Enabled = False
	End If
	If Addres.ReadWheel = StrAddr(1) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(1))
	Else If Addres.ReadWheel = StrAddr(1) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(1))
		string_invPing (2,StrAddr(1))
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(2) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(2))
	Else If Addres.ReadWheel = StrAddr(2) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(2))
		string_invPing (2,StrAddr(2))
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(3) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(3))
	Else If Addres.ReadWheel = StrAddr(3) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(3))
		string_invPing (2,StrAddr(3))
		Timer1.Enabled = False
	End If 	
End Sub 	
Sub FollowLuxOn_Off_tick
	FollowLuxOnOff
End Sub 
Sub FollowLuxOnOff
	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
		string_invPing(6,StrAddr(0))
	Else If Addres.ReadWheel = StrAddr(0) AND  Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOff" Then	
		string_invPing(7,StrAddr(0))
		string_invPing(7,StrAddr(0))
	End If
	If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
		string_invPing(6,StrAddr(1))
	Else If Addres.ReadWheel = StrAddr(0) AND  Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOff" Then	
		string_invPing(7,StrAddr(1))
		string_invPing(7,StrAddr(1))
	End If
	If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
		string_invPing(6,StrAddr(2))
	Else If Addres.ReadWheel = StrAddr(0) AND  Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOff" Then	
		string_invPing(7,StrAddr(2))
		string_invPing(7,StrAddr(2))
	End If
	If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOn" Then
		string_invPing(6,StrAddr(3))
	Else If Addres.ReadWheel = StrAddr(0) AND  Set.ReadWheel = "yes" AND FollowLuxOn_Off.ReadWheel = "FolOff" Then	
		string_invPing(7,StrAddr(3))
		string_invPing(7,StrAddr(3))
	End If
End Sub
Sub DelayOn_Off_tick
	DelayOnOff
End Sub 	
Sub DelayOnOff
	'  fast o slow delay lamp'
	' 0 = max fast; 10 = medium; 20 = slow;
	
	' Groups Lamp'
	
	For i = 0 To PoliciesMode.StrAddr.Size -1
		If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMax" Then
		Dim cursor1 As Cursor
			cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
						Dim Adrquery As String 
		    			Adrquery = cursor1.GetString("Address")
						string_inv(4,Adrquery,0)
						string_inv(4,Adrquery,0)
					Next
		Else If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMed" Then
			cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
		    			Adrquery = cursor1.GetString("Address")
						string_inv(4,Adrquery,10)
						string_inv(4,Adrquery,10)
					Next
		Else If Addres.ReadWheel = PoliciesMode.StrAddr.Get(i) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMin" Then			
			cursor1 = Main.SQL1.ExecQuery2("SELECT Address FROM Address WHERE Groups = ? or Groups1 = ? ",Array As String(Addres.ReadWheel,Addres.ReadWheel))
					For i = 0 To cursor1.RowCount -1		
						cursor1.Position = i
		    			Adrquery = cursor1.GetString("Address")
						string_inv(4,Adrquery,20)
						string_inv(4,Adrquery,20)
					Next
		End If
	Next
	
	'Single Lamp'
	
	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMax" Then
		string_inv(4,StrAddr(0),0)
		string_inv(4,StrAddr(0),0) 	
		Else If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMed" Then
			string_inv(4,StrAddr(0),10)
			string_inv(4,StrAddr(0),10)
		Else If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMin" Then
			string_inv(4,StrAddr(0),20)
			string_inv(4,StrAddr(0),20)
	End If
	If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMax" Then
		string_inv(4,StrAddr(1),0)
		string_inv(4,StrAddr(1),0) 	
		Else If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMed" Then
			string_inv(4,StrAddr(1),10)
			string_inv(4,StrAddr(1),10)
		Else If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMin" Then
			string_inv(4,StrAddr(1),20)
			string_inv(4,StrAddr(1),20)
	End If
	If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMax" Then
		string_inv(4,StrAddr(2),0)
		string_inv(4,StrAddr(2),0) 	
		Else If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMed" Then
			string_inv(4,StrAddr(2),10)
			string_inv(4,StrAddr(2),10)
		Else If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMin" Then
			string_inv(4,StrAddr(2),20)
			string_inv(4,StrAddr(2),20)
	End If 
	If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMax" Then
		string_inv(4,StrAddr(3),0)
		string_inv(4,StrAddr(3),0) 	
		Else If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMed" Then
			string_inv(4,StrAddr(3),10)
			string_inv(4,StrAddr(3),10)
		Else If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" AND DelayOn_Off.ReadWheel = "DelayMin" Then
			string_inv(4,StrAddr(3),20)
			string_inv(4,StrAddr(3),20)
	End If 
	
End Sub 	
Sub Timer1_Tick
	count = count + 1
	Log (count) 
	If Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" Then
			Circle.value = pwm_to_timer0
				If StrAddrPwm(4) <> pwm_to_timer0 Then
					string_inv(3,StrAddr(0),pwm_to_timer0)
				Else If StrAddrPwm(4) = pwm_to_timer0 Then
					Timer1.Enabled = False
					count = 0
					Log ("addr0" & pwm_to_timer0)
				End If 		
	End If
	If Addres.ReadWheel = StrAddr(1) AND Set.ReadWheel = "yes" Then
			Circle.value = pwm_to_timer1
				If StrAddrPwm(5) <>  pwm_to_timer1 Then 
					string_inv(3,StrAddr(1),pwm_to_timer1)
				Else If StrAddrPwm(5) = pwm_to_timer1 Then
					Timer1.Enabled = False
					Log ("addr1" & pwm_to_timer1)
				End If
	End If 
	If Addres.ReadWheel = StrAddr(2) AND Set.ReadWheel = "yes" Then
		Circle.value = pwm_to_timer2
		If StrAddrPwm(6) <>  pwm_to_timer2 Then 
			string_inv(3,StrAddr(2),pwm_to_timer2)
		Else If StrAddrPwm(6) = pwm_to_timer2 Then
			Timer1.Enabled = False
			Log ("addr2" & pwm_to_timer2)
		End If
	End If 	
	If Addres.ReadWheel = StrAddr(3) AND Set.ReadWheel = "yes" Then
		Circle.value = pwm_to_timer3
		If StrAddrPwm(7) <> pwm_to_timer3 Then
			string_inv(3,StrAddr(3),pwm_to_timer3)
		Else If StrAddrPwm(7) = pwm_to_timer3 Then 
			Timer1.Enabled = False
			Log ("addr3" & pwm_to_timer3)
		End If 
	End If  
End Sub 
Sub Set_tick
	Set.ReadWheel
End Sub 	
Sub GoNext1_Click
	'string_inv (5,StrAddr(3),10)
'	string_inv (5,StrAddr(3),FollowLux.ReadWheel)
'	Log ("value of lux" & FollowLux.ReadWheel)
End Sub
Sub Button3_Click
	'string_inv ( 6,StrAddr(3))
End Sub
Sub Button2_Click
	string_invPing (2,StrAddr(0))
End Sub
Sub Button1_Click
	'string_invPing (6,StrAddr(3))
End Sub
Sub SetGroups_Click
	'Pulsante che cambia la lista da grouppo a address'

	If PoliciesMode.StrAddr.IndexOf("") = 0 OR PoliciesMode.StrAddr.Size = 0 Then
		Msgbox("First Must Create Groups","Error")
		Dim result As Int
		result = Msgbox2("Do you want insert Groups","Error","Yes","","No",Null)
		If result = DialogResponse.POSITIVE Then 
			If admin.IsEnabled = True Then
				admin.Disable
			End If 	
			StartActivity("PoliciesMode")
			
		Else
		End If
	Else If PoliciesMode.StrAddr.Size > 0 Then
		Addres.UpdateList(PoliciesMode.StrAddr)
		LabAddress.Text = "Groups"
	End If 	
End Sub
		