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

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Dim table1 As Table
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("sensori")
	table1.Initialize(Me, "Table1", 9)
			table1.AddToActivity(Activity, 0, 0dip, 100%x, 50%y)	
			table1.SetHeader(Array As String("Address", "Lux", "Power", "Temperature", "Humidity", "CO2", "Presence", "Voltage", "Power %"))
			table1.SetColumnsWidths(Array As Int(100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100dip, 100%x - 800dip))
			Activity.AddMenuItem("Jump To 3000", "Jump1")
			Activity.AddMenuItem("Jump To 0", "Jump2")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


