Type=Activity
Version=3.82
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
Dim SQL1 As SQL
Dim cambiovalue As Boolean 
cambiovalue = True
Dim testo1 As String
Dim pippo As String
Public map1 As Map
End Sub

Sub Globals
	Dim table1 As Table
	Dim sf As StringFunctions
   	sf.Initialize
	Dim astreams1 As AsyncStreams
	Private back As Button
	Dim Panel As Panel
	Dim map1 As Map
	Dim row As Int
	Dim s As String
	Dim usb1 As UsbSerial
	Dim json As JSONParser
	Private Header As Panel
	Private prova1 As EditText
	Private find_tel As Button
	Private Send As Button
	Private testo As EditText
	Dim MyDeviceName As String
	Dim lblBT As Label
	Private check_Device As Button
	Dim JSONGenerator As JSONGenerator
	Private ValueLux As SeekBar	
	Private prova2 As String  
	Public hbar As HSeekbar
	End Sub

Sub Activity_Create( firstime  As Boolean)
   	Activity.LoadLayout("sensori") 
	If firstime Then 	
		StartActivity(tables)	
		admin.Initialize("BT")
		serial1.Initialize("Serial1")
		SQL1.Initialize(File.DirDefaultExternal,"test.db",True)
			ToastMessageShow("Database create ",True)
		hbar.setColors(Colors.Black, Colors.white, Colors.rgb(255,180,180), Colors.white) 
	End If
	create_table(False)			
	If serial1.IsEnabled = True Then
		ToastMessageShow("abilit",True )
		End If 
	If admin.IsEnabled = False Then
		admin.Enable
		ToastMessageShow("the bt is ready", True ) 
	Else 
		ToastMessageShow("the bt is just ready" ,True )
	End If
	
End Sub 	
Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub back_Click
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
	table1.SetColumnsWidths(Array As Int(140dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip -1 ))
End Sub

	Sub Astreams1_NewData (Buffer() As Byte)
	Dim u As String
	Dim lpos As Long
	Dim rpos As Long
	u = (BytesToString(Buffer, 0, Buffer.Length, "UTF8"))
	str_ = str_ & u 
	'Log ("buffer lenght" & Buffer.Length)
	If str_.Length > 165 Then
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
					s = sf.Mid(str_,lpos+1,(rpos+lpos)+1)
						If s.Length < 180 Then
						json_interpreter1(s)	'change the buffer'
					str_=sf.Right(str_,(str_.Length-rpos)-1)
						Else 
							str_=""
						End If 
			End If
		
		End If 	
	End If
End Sub
Sub json_interpreter1 (jstr As String)
	json.Initialize(jstr)
	'Dim map1 As Map
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
End Sub 	
	
Sub Activity_Resume
	hbar.Value = 75
	If admin.IsEnabled = False Then
		lblBT.Color = Colors.Black 
				admin.Enable
		Else
			'connect to SK
		 	 check_Device_Click
			 
			'BTConnectToDevice
		End If
		'Catch
		'End Try

End Sub

Sub BT_StateChanged(NewState As Int,OldState As Int)
	If NewState = admin.STATE_ON Then
		'BTConnectToDevice
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
		ToastMessageShow("Bluetooth connected to " & serial1.GetPairedDevices, False)				
		astreams1.Initialize(serial1.InputStream,serial1.OutputStream,"AStreams1")
		'timBT.Enabled = True
	Else	
		ToastMessageShow("Connection to " & serial1.GetPairedDevices & _
						" broken!", True)
		'timBT.Enabled = False
		'btConnected = False
	End If
End Sub

Sub AStreams_NewData ( buffer () As Byte)
	Dim s As String
	s = BytesToString( buffer , 0 , buffer.Length, "UTF-8")
	Log(serial1.InputStream)
	Log (s.Length)
	json_interpreter1(s)
End Sub
'Sub Send_Click 
	'astreams1.Write(testo.Text.GetBytes("UTF-8"))	
	'testo.SelectAll
	'testo.RequestFocus
	'Dim testo1 As String
	'Dim u As String
	'Dim b As String
	'u = ";"
	'b = ","
	'testo1 = 3,&u
	'ValueLux.Max= 10
	'Dim pippo As String
	'pippo = ValueLux.Value
	'Dim arr(10) As Int
	'arr(0) = 3
	'arr(1) = 5
	'arr(2) = 100 'ValueLux.Max
	'testo1 = "3," & "0x0013a200406ff46e" & b & pippo & u
	'arr = testo1.get(0)
	'Log ("prova"  & testo1)
	'Log ("quale testo" & testo1)
	'testo.Text = testo1 
	'Log (serial1.OutputStream)
	'Log ("addr64 send_click " &  testo.Text)
'End Sub
Sub check_Device_Click
	Dim PariredDevices As Map
	PariredDevices = serial1.GetPairedDevices
	Dim l As List
	l.Initialize
	For I = 0 To PariredDevices.Size -1
	l.add(PariredDevices.GetKeyAt(I))
	Next 
	Dim res As Int
	res = InputList(l,"choise device", -1)
	If res <> DialogResponse.CANCEL Then
	serial1.Connect(PariredDevices.Get(l.Get(res)))
	'serial1.Listen
	End If
End Sub	
Sub create_table (firstime As Boolean) 
	If firstime  Then 
		SQL1.ExecNonQuery("create table Tabdisc (pktype Text , col1 INTERGER ,col3 INTERGER)")
		ToastMessageShow("table create success",True)
		Log ("pass here")
	Else
		'SQL.ExecNonQuery("create table Tabdisc (pktype Text , col1 INTEGER ,col3 INTERGER)")
		ToastMessageShow("table just create",True)
	End If   
	
End Sub
Sub sql_proof_Click (success As Boolean)
If success = True Then
	SQL1.ExecNonQuery("insert into Tabdisc values('proof',12,15)")
	ToastMessageShow("insert success",True)
Else
	ToastMessageShow("dati gia inseriti",True) 	
End If
End Sub
'Sub ValueLux_ValueChanged (value As Int, UserChanged As Boolean)
'	If UserChanged Then 
'		String_inv(value)
'		'testo.text = testo1.SubString2(21,23)
'		testo.text = value
'	End If 
'End Sub
Sub String_inv(value As Int )
	astreams1.Write(testo1.GetBytes("UTF-8"))
	Dim arr(3) As String
	Dim lis As List
	lis.Initialize
	If map1.Get("address64") = "0x0013a20040be447f" Then 
		arr(0) = map1.get("address64")
	End If 	
	Log("lista" & arr(0))
	testo1 = "3," & "0x0013a20040be447f" & "," & value & ";"
	Log ("addr64 send_click " &  value)
End Sub 	

Sub hbar_ValueChanged(value As Int, UserChanged As Boolean)
	If UserChanged Then 
		String_inv(value)
		testo.text = value
	End If 	
End Sub
 	 	