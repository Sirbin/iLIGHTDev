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
	Public str_ As String
	Dim serial1 As Serial
	Dim admin As BluetoothAdmin
	Dim btConnected As Boolean 
	Dim timBT As Timer 
	Dim AStreams As AsyncStreams
	Dim cambiovalue As Boolean 
	cambiovalue = True
	Dim testo1 As String
	Public l As List
	l.Initialize
	Public map1 As Map
	Public json As JSONParser
	Dim Clock1 As Timer
	Dim sec1 As Int
End Sub

Sub Globals
	Dim table1 As Table
	Dim sf As StringFunctions
   	sf.Initialize
	Dim astreams1 As AsyncStreams
	Private back As Button
	Dim Panel As Panel
	Dim s As String
	'Dim usb1 As UsbSerial
	Private Header As Panel
	Private prova1 As EditText
	Private find_tel As Button
	Private Send As Button
	Private testo As EditText
	Dim MyDeviceName As String
	Private check_Device As Button
	Private prova2 As String  
	Public hbar As HSeekbar
	End Sub

Sub Activity_Create( firstime  As Boolean)
   	Activity.LoadLayout("sensori") 
	If firstime Then 	
		StartActivity(tables)	
		admin.Initialize("BT")
		serial1.Initialize("Serial1")
	End If
	If admin.IsEnabled = False Then
		admin.Enable 
		Log("Bt is ready")
	End If  
	If table1.IsInitialized = False Then 
		tables
	End If
End Sub 	
Sub Activity_Pause (UserClosed As Boolean)
End Sub


Sub back_Click
	
	If admin.IsEnabled = True Then 
		admin.disable
		Log("Bt as Disable")
	End If 
	Activity.Finish
	'serial1.Disconnect
	l.Clear
	StartActivity("main")
	
End Sub 
Sub tables
	table1.Initialize(Me,"table1",9,Gravity.CENTER_HORIZONTAL,True )
	table1.AddToActivity(Panel , 0, 0, 100%x,100%y)	
    table1.SetHeader(Array As String("Address64", "Power", "Temperature", "Humidity", "Lux", "CO2", "Presence", "Voltage", "Power %"))
	table1.insertRowAt(0,Array As String("null","null","null","null","null","null","null","null","null"))
	table1.insertRowAt(1,Array As String("3","34","5","5","5","7","5","42","22")) 
	table1.insertRowAt(2,Array As String("6","4","8","3","5","7","5","6","22"))
	table1.insertRowAt(3,Array As String("9","8","26","3","5","7","6","42","22"))	 
	table1.SetColumnsWidths(Array As Int(150dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip -1 ))
End Sub

Sub Astreams1_NewData (Buffer() As Byte)
	Dim u As String
	Dim lpos As Long
	Dim rpos As Long
	u = BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	str_ = str_ & u
	'Log ("buffer lenght" & Buffer.Length)
	Log(str_)
	'Log(str_.Length)
	If str_.Length > 180 Then
		lpos=str_.IndexOf("{")
		rpos=str_.IndexOf2("}",lpos+1)
		'Log ("inizio" &lpos)
		'Log ("fine" &rpos)
		'rpos = str_.IndexOf("}")
		If lpos < 0 Then
			'Log("lpos negativo ----------------------------------------------")
			str_=" "
		End If		
		If lpos>=0 Then
			If rpos > lpos Then  	
					'If str_.Length < 170 Then
					s = sf.Mid(str_,lpos+1,(rpos+lpos)+1)
						'If s.Length < 170 Then
							json_interpreter1(s)	'change the buffer'
							str_=sf.Right(str_,(str_.Length-rpos)-1)
						'Else 
							'str_=""
						'End If 
			End If
		
		End If 	
	End If
End Sub
Sub json_interpreter1 (jstr As String)
	Try
	json.Initialize(jstr)
	map1.Initialize
	map1=json.NextObject
		If map1.Get("address64") = "0x0013a20040be447f" Then 
			table1.UpdateRow(0,Array As String(map1.Get("address64"),map1.Get("power") ,map1.Get("temperature") ,map1.Get("humidity"),map1.Get("lux"),map1.Get("co2"),map1.Get("presence"),map1.Get("voltage"),map1.Get("pwm")))   				
		End If 
		If map1.Get("address64") = "0x0013a200406ff46e" Then
			table1.UpdateRow(1,Array As String(map1.Get("address64"),map1.Get("power") ,map1.Get("temperature") ,map1.Get("humidity"),map1.Get("lux"),map1.Get("co2"),map1.Get("presence"),map1.Get("voltage"),map1.Get("pwm")))
		End If 
		If map1.Get("address64") = "0x0013a20040332051" Then 
			table1.UpdateRow(2,Array As String(map1.Get("address64"),map1.Get("power") ,map1.Get("temperature") ,map1.Get("humidity"),map1.Get("lux"),map1.Get("co2"),map1.Get("presence"),map1.Get("voltage"),map1.Get("pwm")))	
		End If 
		If map1.Get("address64") = "0x0013a20040626109" Then
			table1.UpdateRow(3,Array As String(map1.Get("address64"),map1.Get("power") ,map1.Get("temperature") ,map1.Get("humidity"),map1.Get("lux"),map1.Get("co2"),map1.Get("presence"),map1.Get("voltage"),map1.Get("pwm")))
		End If 
	Catch
		admin.Disable 
		Clock1.Initialize("Clock1", 1000)
		Clock1.Enabled = True 	
	End Try	
End Sub 	
Sub Clock1_tick
	sec1 = sec1 + 1
	If sec1 > 5 Then 
			admin.Enable
			BT_StateChanged(1,0)
				If admin.Enable = True Then
					Clock1.Enabled = False
				End If			
	End If 
End Sub

Sub Activity_Resume 
	'hbar.Value = 75
	If admin.IsEnabled = False Then
 		admin.Enable
	End If
End Sub

Sub BT_StateChanged(NewState As Int,OldState As Int)
	If NewState = admin.STATE_ON Then
		Connect_3box
		Log("BT Connect")
	Else 
		serial1.Disconnect 
		timBT.Enabled = False
		Log("BT Disconnect")
	End If
End Sub
Sub Serial1_Connected (success As Boolean)
 Dim msg As String 
	If success = True Then
		ToastMessageShow("bt connesso successo" ,True)
		ToastMessageShow("Bluetooth connected to " & l.Get(0),False)'serial1.GetPairedDevices, False)				
		astreams1.Initialize(serial1.InputStream,serial1.OutputStream,"AStreams1")
		'timBT.Enabled = True
	Else	
		ToastMessageShow("Connection to " & l.Get(0) & "broken!",True)
		'timBT.Enabled = False
		'btConnected = False
	End If
End Sub
Sub Connect_3box 
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
	