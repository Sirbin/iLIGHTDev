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
	Public AddrsNode As LinkedList
	AddrsNode.Initialize
	Public lstaddr As List
	lstaddr.Initialize
	Public sql1 As SQL
End Sub


Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
		
End Sub

Sub Activity_Create(FirstTime As Boolean)
	sql1.Initialize(File.DirInternal,"database.db",True)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
