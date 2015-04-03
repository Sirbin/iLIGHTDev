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

End Sub

Sub Globals
	

End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("configuration")
	

End Sub

Sub Activity_Resume
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
Sub Back_Click
	StartActivity("main")
End Sub
Sub cs_ValueChanged(Value As Int, UserChanged As Boolean)
Log("cs " & Value& "  " & UserChanged)
End Sub