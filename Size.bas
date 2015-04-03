Type=StaticCode
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Private Sub Process_Globals
	'These global variables will be declared once when the application starts.
Private	Large, Small As Int
Private sx, sy  As Float
Public  Cf  As Float
End Sub

'Resize all the views, including those on panels, to the Device's size.
Public Sub SetSize(Act As activity, DesignLargeAxis As Int, DesignSmallAxis As Int)
Dim v As View
Dim DesDiag2, RealDiag2 As Float
Large = DesignLargeAxis * Density
Small = DesignSmallAxis * Density

If 100%x > 100%y Then
	sx = 100%x /Large
	sy = 100%y/Small

Else
	sx = 100%x/Small
	sy = 100%y/Large

End If

DesDiag2 = Large*Large + Small*Small
RealDiag2 = 100%y * 100%y + 100%x * 100%x
Cf =  Sqrt(RealDiag2/DesDiag2)' / Density   ' font size factor

For i = 0 To Act.NumberOfViews -1
	v = Act.GetView(i)
	Modify(v)
Next
End Sub

Private Sub Modify(v As View)
v.SetLayout( v.left * sx , v.top * sy, v.width * sx ,  v.height * sy ) 
If v Is Button OR _ 
	v Is CheckBox OR _
	 v Is EditText OR _
	  v Is Label OR _ 
	   v Is RadioButton OR _ 
	    v Is Spinner OR _ 
	     v Is ToggleButton Then
	SetFont(v)
Else 
	If v Is Panel Then SetPanel(v)
End If
End Sub

Private Sub SetPanel(Vp As View)
Dim P As Panel
Dim v As View
P = Vp
For i = 0 To P.NumberOfViews -1
	v = P.GetView(i)
	Modify(v)
Next
End Sub

Private Sub SetFont(V As View)
Select GetType(V) 
	Case "android.widget.Button"
		Dim B As Button
		B = V
		B.TextSize = B.TextSize * Cf
	Case "android.widget.EditText"
		Dim E As EditText
		E = V
		E.TextSize = E.TextSize * Cf
	Case "android.widget.TextView"
		Dim L As Label
		L = V
		L.TextSize = L.TextSize * Cf
	Case "android.widget.RadioButton"
		Dim R As RadioButton
		R = V
		R.TextSize = R.TextSize * Cf
	Case "android.widget.CheckBox"
		Dim C As CheckBox
		C = V
		C.TextSize = C.TextSize * Cf
	Case "anywheresoftware.b4a.objects.SpinnerWrapper$B4ASpinner"
		Dim S As Spinner
		S = V
		S.TextSize = S.TextSize * Cf 
	Case "android.widget.ToggleButton"
		Dim T As ToggleButton
		T = V
		T.TextSize = T.TextSize * Cf
End Select
End Sub

