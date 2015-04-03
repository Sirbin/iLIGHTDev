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

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
    
	
	Private TNE_iLight As Label
	Private Manual As Button
	Private Back As Button
	Private WizardIcom As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("ConfigPage")

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub Manual_Click
	StartActivity("ConfigurationManual.bas")
End Sub
Sub Back_Click
	StartActivity("Main")
End Sub

Sub WizardIcom_Click
	StartActivity("ConfigurationWizardMod")
End Sub
Sub Finish1_Click
    Activity.Finish
End Sub	