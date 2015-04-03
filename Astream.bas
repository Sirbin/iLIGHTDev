Type=StaticCode
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public json As JSONParser
	Public btConnected As Boolean
	Public admin As BluetoothAdmin
	Public serial1 As Serial
	Public astreams1  As AsyncStreams
	Public map1 As Map
	Public l  As List
	l.Initialize
	Public Lstaddr As List
	Lstaddr.Initialize
	Public str_ , s As String
	Public sf As StringFunctions
	'sf.Initialize
	Public SQL1 As SQL
	SQL1.Initialize(File.DirRootExternal, "iLight.db", True) 'Database '
	Public groups_default As String  'Default String for Database'
	groups_default = "Default"
	Public  tbl As Map
	tbl.Initialize
End Sub
Sub BT_StateChanged(NewState As Int,OldState As Int)
	If NewState = admin.STATE_ON OR admin.IsEnabled = True Then
		Connect_3box
		Log("BT Connect")
	Else 
		serial1.Disconnect 
		Log("BT Disconnect")
		Return 
	End If
End Sub

Sub Serial1_Connected (success As Boolean) 
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
Sub Astreams1_NewData (Buffer() As Byte)
	Dim u As String
	Dim lpos As Long
	Dim rpos As Long
	u = u & BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	str_ = str_ & u 
	Log (str_)
	If str_.Length > 180 Then
		lpos=str_.IndexOf("{")
		rpos=str_.IndexOf2("}",lpos+1)
			If lpos < 0 Then
				Log("lpos negativo ----------------------------------------------")
				str_=" "
			End If		
		If lpos>=0 Then
			If rpos > lpos Then  	
					s = sf.Mid(str_,lpos+1,(rpos+lpos)+1)
					json_interpreter1(s)	'change the buffef
					str_=sf.Right(str_,(str_.Length-rpos)-1)
			End If
		
		End If 	
	End If
End Sub
Sub json_interpreter1 (jstr As String)
	Try 
		json.Initialize(jstr)
		map1.Initialize
		map1=json.NextObject 
			If map1.Get("pktype") = "hello" Then
				If Lstaddr.Size = 0 Then
					Lstaddr.add(map1.Get("address64"))
					ToastMessageShow("New Address"  & map1.Get("address64"),True)
					Log (Lstaddr)
				Else	
					If 	Lstaddr.IndexOf(map1.Get("address64")) = -1 Then 
							Lstaddr.Add(map1.Get("address64"))
						ToastMessageShow("New Address"  & map1.Get("address64"),True)
						Log (Lstaddr) 
						
					Else
						ToastMessageShow("Address is present" ,True)
					End If 
					
				
				End If 	
			End If 
	Catch
		Return
	End Try	
End Sub