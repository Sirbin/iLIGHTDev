Type=Activity
Version=3.82
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
	Dim timercoll As Timer
	'Public admin As BluetoothAdmin
	'Public serial1 As Serial
	'Public json As JSONParser
	'Public map1 As Map
	Public invio_dati As String 
	Public StrAddrPwm(10) As Int
	Public StrAddr(4) As String
	Public add(4) As String ' provvisoria
	Public sec,count As Int
	'Public lstaddr As List
	'lstaddr.Initialize
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
	'Dim str_,s As String
	'Dim sf As StringFunctions
   	'sf.Initialize
	'Dim astreams1 As AsyncStreams
	Public Label1 As Label
	Dim l As List 
	l.Initialize 
	Private lblFont As Typeface
	Private lblLuxValue As Label
	Private Circle,Circle1,Circle2 As CircleSeek
	Dim arr(5) As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	If FirstTime Then 		
		Main.admin.Initialize("BT")
		Main.serial1.Initialize("Serial1")
		Main.serial1.Connect(Main.l.Get(0))
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
	If Main.admin.IsEnabled = False Then
		Main.admin.Enable 
		Log("Bt is ready") 	
	End If
	If Main.serial1.IsEnabled = True Then
		Main.serial1.Connect(Main.l.Get(0))
		Log ("connesso")
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
	If Main.admin.IsEnabled = False Then
 		Main.admin.Enable
	End If 	
	If Main.serial1.IsEnabled = True Then 
		Main.serial1.Connect(Main.l.Get(0))
		Log ("connesso resume")
	End If 	
End Sub		
Sub Label_create
	Dim LabAddress As Label
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
	Addres.Initialize1(svsstep,StrAddr,True,"Addres")
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
Sub create_scr
'	'Panel1 = Scroll.Panel
'	'lstcheck.Initialize
'	'Dim lbllux0 As Label
'	'Dim lbllux1 As Label
'	Dim lbllux2 As Label
'	Dim lbllux3 As Label
'	lbllux0.Initialize("")
'	lbllux1.Initialize("")
'	lbllux2.Initialize("")
'	lbllux3.Initialize("")
'	lbllux0.TextSize = 80
'	lbllux0.TextColor = Colors.RGB(50,205,50)
'	Panel1.AddView(lbllux0,50%x,9%x,80%x,50%y)
'	lbllux1.TextSize = 80
'	lbllux1.Color = Colors.Transparent
'	lbllux1.TextColor = Colors.RGB(50,205,50)
'	Panel1.AddView(lbllux1,50%x,19%x,80%x,50%y)
'	
'	chk0.Initialize("")
'	chk1.Initialize("")
'	chk2.Initialize("")
'	chk3.Initialize("")
'	chk0.Text = "0x0013a20040be447f"
'	chk0.TextColor = Colors.RGB(227,227,227)
'	chk0.TextSize = 45
'	chk1.Text = "0x0013a200406ff46e"
'	chk1.TextColor = Colors.RGB(227,227,227)
'	chk1.TextSize = 45
'	chk2.Text =  "0x0013a20040332051"
'	chk2.TextColor = Colors.RGB(227,227,227)
'	chk2.TextSize = 45
'	chk3.Text = "0x0013a20040626109"
'	chk3.TextColor = Colors.RGB(227,227,227)
'	chk3.TextSize = 45
''	lstcheck.AddAll(Array As String(chk0.Text,chk1.Text,chk2.Text,chk3.Text))
''	For x = 0 To lstcheck.Size -1
''		dat(0) = lstcheck.Get(0)
''		dat(1) = lstcheck.Get(1)
''		dat(2) = lstcheck.Get(2)
''		dat(3) = lstcheck.Get(3)
''		Log(dat(1))
'		Log(dat(0))
''	Next
'	Panel1.AddView(chk0,0,0%x,50%x,50%y)
'	Panel1.AddView(chk1,0,20%x,50%x,50%y)
'	Panel1.AddView(chk2,0,40%x,100%x,50%y)
'	Panel1.AddView(chk3,0,60%x,100%x,50%y)

End Sub	
Sub create_list
'	dat(0) = "0x0013a20040be447f"
'	dat(1) = "0x0013a200406ff46e"
'	dat(2) = "0x0013a20040332051"
'	dat(3) = "0x0013a20040626109"
'	Address.AddSingleLine(dat(0))
'	Address.AddSingleLine(dat(1))
'	Address.AddSingleLine(dat(2))
'	Address.AddSingleLine(dat(3))
'	Address.SingleLineLayout.ItemHeight = 80dip
'    Address.SingleLineLayout.Label.TextSize = 30
'	Address.SingleLineLayout.Label.Gravity = Gravity.CENTER_HORIZONTAL
'	Address.SingleLineLayout.Label.TextColor = Colors.RGB(227,227,227)
'	init_label
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
	Main.str_ = Main.str_ & u 
	'Log ("buffer lenght" & Buffer.Length)
	Log(Main.str_)
	'Log(str_.Length)
	If Main.str_.Length > 165 Then
		lpos=Main.str_.IndexOf("{")
		rpos=Main.str_.IndexOf2("}",lpos+1)
		'Log ("inizio" &lpos)
		'Log ("fine" &rpos)
		'rpos = str_.IndexOf("}")
		If lpos < 0 Then
			Log("lpos negativo ----------------------------------------------")
			Main.str_=" "
		End If		
		If lpos>=0 Then
			If rpos > lpos Then  	
					Main.s = Main.sf.Mid(Main.str_,lpos+1,(rpos+lpos)+1)
						'If str_.Length < 170 Then
							json_interpreter1(Main.s)	'change the buffer'
							Main.str_=Main.sf.Right(Main.str_,(Main.str_.Length-rpos)-1)
						'Else 
						'	str_=""
						'End If 
			End If
		
		End If 	
	End If
End Sub

Sub json_interpreter1 (jstr As String)
	Try 
	Main.json.Initialize(jstr)
	Main.map1.Initialize
	Main.map1=Main.json.NextObject
	If Main.map1.Get("pktype") = "hello" Then 
		Liste.lstaddr.add(Main.map1.Get("address64"))
		Log (Liste.lstaddr)
	Else If Main.map1.Get("pktype") = "reply" Then
		If Main.map1.Get("command") =  "3" Then
			arr = Main.map1.Get("value")
		Else If Main.map1.Get("command") = "1" Then
			arr = Main.map1.Get("value")
		Else If Main.map1.Get("command") = "2" Then
			arr = Main.map1.Get("value") 	
		Else If Main.map1.Get("command") = "4" Then
			arr(1) = Main.map1.Get("value")
		Else If Main.map1.Get("command") = 10 Then
			arr(1) = Main.map1.Get("value")
		Else If Main.map1.Get("command") = 11 Then
			arr(2) = Main.map1.Get("value")
		Else If Main.map1.Get("command") = 5 Then 
			arr(3) = Main.map1.Get("value")
		Else If Main.map1.Get("pktype") = "sensors" Then
		End If 
	Else If Main.map1.Get("pktype") = "sensors" Then 	
		Take_Address_Take_Pwm
	End If  	
	Catch
		Main.admin.Disable 
		timercoll.Initialize("TimerColl", 1000)
		timercoll.Enabled = True
	End Try	
End Sub 	
Sub TimerColl_tick
	sec = sec + 1
	If sec > 5 Then 
			Main.admin.Enable
			BT_StateChanged(1,0)
				If Main.admin.Enable = True Then
					timercoll.Enabled = False
				End If			
	End If 
End Sub	
Sub Take_Address_Take_Pwm 
' Pwm Valor of Address
		If Main.map1.Get("address64") = "0x0013a20040be447f" Then
				StrAddrPwm(4) = Main.map1.Get("pwm") 
		Else If Main.map1.Get("address64") = "0x0013a200406ff46e" Then 
				StrAddrPwm(5) = Main.map1.Get("pwm")
		Else If Main.map1.Get("address64") = "0x0013a20040332051" Then
				StrAddrPwm(6) = Main.map1.Get("pwm")
		Else If Main.map1.Get("address64") = "0x0013a20040626109" Then 
				StrAddrPwm(7) = Main.map1.Get("pwm")
		End If	
	End Sub 	
Sub BT_StateChanged(NewState As Int,OldState As Int)
	If NewState = Main.admin.STATE_ON Then
		Connect_3box
		Log("BT Connect")
	Else 
		Main.serial1.Disconnect 
		Log("BT Disconnect")
	End If
End Sub
Sub Serial1_Connected (success As Boolean)
 Dim msg As String 
	Try 
	If success = True Then
		ToastMessageShow("Bluetooth connect with success" ,True)
		ToastMessageShow("Bluetooth connected to " & Main.l.Get(0),False)				
		Main.astreams1.Initialize(Main.serial1.InputStream,Main.serial1.OutputStream,"AStreams1")
	Else	
		ToastMessageShow("Connection to " & Main.l.Get(0) & "broken!",True)
	End If
	Catch
		Return 
	End Try	
End Sub
Sub Connect_3box 
	Public PariredDevices As Map
	Dim MyDevice As String
	MyDevice = "3box"
	PariredDevices = Main.serial1.GetPairedDevices		
	If PariredDevices.ContainsKey(MyDevice) Then 
		Main.l.add(PariredDevices.Get(MyDevice))
		Log(Main.l)
	End If 
	Main.serial1.Connect(Main.l.Get(0))
End Sub	
Sub Addres_tick
	Addres.ReadWheel 
End Sub 	
Sub string_invPing(cmd As Int ,Addr As String)
	Main.astreams1.Write(invio_dati.GetBytes("UTF-8"))
	If cmd = 1 Then 				' Set Ping ON
		invio_dati = "1," & Addr & ";"
		Log ("pingon" &invio_dati)
	Else If cmd = 2 Then            ' Set Ping OFF
		invio_dati = "2," & Addr & ";" 
		Log ("pingoff" &invio_dati)
	Else If cmd = 6 Then  			' Set Follow On
		invio_dati = "6," & Addr & ";"
		Log (invio_dati)
	Else If cmd = 7 Then			' Set Follow OFF
		invio_dati = "7," & Addr & ";"
		Log (invio_dati)
	Else If cmd = 8 Then			' Set Presence On
		invio_dati = "8," & Addr & ";"
		'Log (invio_dati)
	Else If cmd = 9 Then			' Set Presence OFF
		invio_dati = "9," & Addr & ";"
		'Log (invio_dati)
	End If
End Sub	
Sub string_inv(cmd As Int, Addr As String, value As Int )
	Main.astreams1.Write(invio_dati.GetBytes("UTF-8"))	
	If cmd = 3 Then 				' Set Light Value
		invio_dati = "3," & Addr & "," & value & ";"
		'Log ( invio_dati)
	Else If  cmd = 4 Then 				'Set Delay value (0 = Fast , 20 = Slow)
		invio_dati = "4," & Addr & "," & value & ";"
		Log ("prog" & invio_dati)
	Else If cmd = 5 Then 			' Set FollowLux Value
		invio_dati = "5," & Addr & "," & value & ";"
		Log (invio_dati)
	Else If cmd = 10 Then 			' Set Presence High Value
		invio_dati = "10," & Addr & "," & value & ";"
		'Log (invio_dati)
	Else If cmd = 11 Then 			' Set Presence Low Value
		invio_dati = "11," & Addr & "," & value & ";"
		'Log (invio_dati)	
	End If
	
End Sub 	
Sub GoBack1_Click
    If Main.admin.IsEnabled = True Then 
		Main.admin.disable
		Log("Bt as Disable")
	End If 
	Activity.Finish
	l.Clear
	StartActivity("main")
End Sub
Sub Circle_ValueChanged(value As Int,UserChanged As Boolean)
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
Sub Circle1_ValueChanged(value As Int,UserChanged As Boolean)
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
Sub Circle2_ValueChanged(value As Int ,UserChanged As Boolean)
	If UserChanged  AND Addres.ReadWheel = StrAddr(0) AND Set.ReadWheel = "yes" Then
		If Timer3.Enabled = False Then 
			Timer3.Enabled = True
		End If 	
		pwm_Foll0 = value
		Log (pwm_Foll0)
	End If
End Sub 
Sub Timer3_tick
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
	If Addres.ReadWheel = StrAddr(0) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(0))
	Else If Addres.ReadWheel = StrAddr(0) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing(2,StrAddr(0))
		string_invPing(2,StrAddr(0))
		'Circle.value = StrAddrPwm(4)
		Timer1.Enabled = False
	End If
	If Addres.ReadWheel = StrAddr(1) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(1))
	Else If Addres.ReadWheel = StrAddr(1) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(1))
		string_invPing (2,StrAddr(1))
		'Circle.value = StrAddrPwm(5)
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(2) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(2))
	Else If Addres.ReadWheel = StrAddr(2) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(2))
		string_invPing (2,StrAddr(2))
		'Circle.value = StrAddrPwm(6)
		Timer1.Enabled = False
	End If 
	If Addres.ReadWheel = StrAddr(3) AND choice.ReadWheel = "On" AND Set.ReadWheel = "yes" Then
		string_invPing(1,StrAddr(3))
	Else If Addres.ReadWheel = StrAddr(3) AND choice.ReadWheel = "Off" AND Set.ReadWheel = "yes" Then
		string_invPing (2,StrAddr(3))
		string_invPing (2,StrAddr(3))
		'Circle.value = StrAddrPwm(7)
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
'	If UserChanged Then
'		ControllAddr(value)
'	End If 	
'		If Addres.ReadWheel = StrAddr(0) Then 
'			lblFont = Typeface.LoadFromAssets("digi.ttf")
'			String_inv(3,StrAddr(0),value)
'		Else If  Addres.ReadWheel = StrAddr(1) Then
'			lblFont = Typeface.LoadFromAssets("digi.ttf")
'			String_inv(3,StrAddr(1),value)
'		Else If Addres.ReadWheel = StrAddr(2) Then
'			lblFont = Typeface.LoadFromAssets("digi.ttf)
'			String_inv(3,StrAddr(2),value)
'		Else If Addres.ReadWheel = StrAddr(3) Then
'			String_inv(3,StrAddr(3),value)
'			lblFont = Typeface.LoadFromAssets("digi.tff")
' 		End If 
'		lblLuxValue.TextSize = 80
'		lblLuxValue.Text = value
'		lblLuxValue.Typeface = lblFont
'	End If 	
'		If chk1.Checked = True Then 
'			lbllux1.Text = value
'			lbllux1.Typeface = lblFont
 
'Sub ControllAddr
'	If Addres.ReadWheel = StrAddr(0) Then 
'			Circle.Value = StrAddrPwm
'	End If 		
'End Sub	
'	Else If  Addres.ReadWheel = StrAddr(1) Then
'			lblFont = Typeface.LoadFromAssets("digi.ttf")
'			String_inv(3,StrAddr(1),value)
'		Else If Addres.ReadWheel = StrAddr(2) Then
'			lblFont = Typeface.LoadFromAssets("digi.ttf")
'			String_inv(3,StrAddr(2),value)
'		Else If Addres.ReadWheel = StrAddr(3) Then
'			String_inv(3,StrAddr(3),value)
'			lblFont = Typeface.LoadFromAssets("digi.tff")
' 		End If 
'		lblLuxValue.TextSize = 80
'		lblLuxValue.Text = value
'		lblLuxValue.Typeface = lblFont

'End Sub 
'Sub Address_ItemClick (Position As Int, value As Object)
'	Try
'		If	value = dat(0) Then 
'			myACET1.Visible = True
'			myACET1.Text = something1
'			lblLuxValue.Text = arr(4)
'			Circle.value = arr(4)
'			myACET1.BringToFront 	
'		Else If value = dat(1)  Then
'			'myACET1.Enabled = False 
'			'myACET3.Visible = False 
'			'myACET4.Visible = False
'			myACET2.Visible = True
'			myACET2.Text = something2
'			lblLuxValue.Text = arr(5)
'			Circle.value = arr(5)
'			myACET2.BringToFront
'		Else If value = "Ad_Nod3"  Then
'			myACET2.Text = ""  
'			myACET4.Text = ""
'			myACET1.Text = ""
'			myACET3.Text = arr(2)
'			lblLuxValue.Text = arr(6)
'    		Circle.value = arr(6)
'			myACET3.BringToFront
'		Else If value = "Ad_Nod4" Then
'			myACET2.Text = "" 
'			myACET3.Text = "" 
'			myACET1.Text = ""
'			myACET4.Text = arr(3)
'			lblLuxValue.Text = arr(7)
'			Circle.value = arr(7)
'			myACET4.BringToFront	
'		
'		End If
'	Catch
'		Msgbox("Wait A correct address","Address")
'	End Try	
'End Sub



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