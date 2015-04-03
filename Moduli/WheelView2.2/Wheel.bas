Type=Class
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Event 
#Event: Roll(stepval As String)
'#Event: ScrollChanged(Position as int) ' not needed

'Class module
Sub Class_Globals
Private Wwheelstep, newposition,WHeight,  Wtextsize, Wlblgravity, Wdelay  As Int
Private sv As ScrollView
Private mp As Panel
Private overlay As ImageView
Private Wmodule As Object
Private lbw As Label
Private Wtextcolor, Wlblcolor As Long
Private Wvalues(2), WEventName As String 
Private tmr As Timer
Private Wcyclic  As Boolean
Private wtf As Typeface
Private des_flag As Boolean
End Sub

'Initializes the Wheel. Needed only when definition of the Wheel is by code, not by Designer.
' module - the name of the activity or service which init the wheel.
' EventName - the name of the wheel
' Read the displayed value in the wheel event "_Roll(value as string)", raised for any change in wheel position.
Sub initialize(module As Object,  EventName As String)
	Wmodule = module
	WEventName = EventName
End Sub	

' Needed only when definition of the Wheel is by code, not by Designer.
' wheelstep - the height of each label in the wheel.
' cyclic - if the wheel is a loop or a line.
' o (object) - can be the list of items or a string array or a string array of size 2 with start and end numbers.
Public Sub CodeCreationView( wheelstep As Int,  cyclic As Boolean, o As Object )
	Wwheelstep = wheelstep
	Wcyclic = cyclic
	Wtextsize = 24
	Wtextcolor = Colors.Black ' default for text color
	Wlblcolor = Colors.WHITE  ' default for labels color
	Wlblgravity =  Gravity.CENTER ' default for gravitiy
	wtf = Typeface.DEFAULT
	Wdelay = 1000 ' default for wheel delay to jump to exact value
	mp.initialize("")
	des_flag = False
	SetObject(o)
End Sub

'Run by designer only
Private Sub DesignerCreateView(base As Panel, Lbl As Label, Props As Map)'ignore
mp = base
Dim st As String = Lbl.text
If st <> "" Then 
	If st.Contains(",") Then
		Dim str() As String = Regex.Split(",",st)
		If IsNumber(str(0)) Then Wwheelstep = str(0)
		If str(1).ToLowerCase = "true" Then Wcyclic = True Else Wcyclic = False
	Else
		If IsNumber(st) Then 
			Wwheelstep = Lbl.text 
			Wcyclic = True
		Else
			Wwheelstep = Lbl.Height/3.2
			If st.ToLowerCase = "true" Then Wcyclic = True Else Wcyclic = False
		End If
	End If
Else
	Wwheelstep = Lbl.Height/3.2
	Wcyclic = True
End If


Wtextsize = Lbl.TextSize
Wtextcolor = Lbl.TextColor
Dim cnvs As Canvas
cnvs.initialize(Lbl)
Wlblcolor = cnvs.Bitmap.GetPixel(1,1)
Wlblgravity =  Lbl.Gravity
wtf = Lbl.Typeface
Wdelay = 1000 ' default for wheel delay to jump to exact value
des_flag = True
End Sub

' o (object) - can be the list of items or a string array or a string array of size 2 with start and end numbers. In the last option the wheel will be filled with numbers with difference of 1 between the first and the last.
'Only if the wheel is defined by the designer, add this by code to start the wheel, after the object is defined by code.
Public Sub SetObject(ob As Object)
If ob Is List Then 
	Dim L As List
	L = ob
	SetValuesByList(L)
Else
	Dim st() As String
	st = ob
	If st.Length > 2 Then
		SetValuesByArray(st)
	Else
		SetValuesByInt(st(0), st(1))
	End If
End If
init_view
End Sub

Private Sub SetValuesByList( List1 As List)  
Dim n As Int
If Wcyclic Then
	n = List1.Size + 2
	Dim Wvalues(n) As String
	Wvalues(0) = List1.Get(n-3)
	For i = 1 To n-2   
		Wvalues(i) = List1.Get( i-1)
	Next
	Wvalues(n-1) = List1.Get(0)
Else
	n = List1.Size 
	Dim Wvalues(n) As String
	For i = 0 To n-1   
		Wvalues(i) = List1.Get(i)
	Next
End If
End Sub

Private Sub SetValuesByArray( values() As String)  
Dim n As Int
If Wcyclic Then
    n = values.length + 2
	Dim Wvalues(n) As String
   	Wvalues(0) = values(n-3)
	For i = 1 To n-2   
		Wvalues(i) = values( i-1)
	Next
	Wvalues(n-1) = values(0)
Else
	n = values.length 
	Dim Wvalues(n) As String	
	For i = 1 To n-1   
		Wvalues(i) = values(i)
	Next
End If
End Sub

Private Sub SetValuesByInt( First As Int, Last As Int)
Dim n As Int
If Wcyclic Then
	n = Last - First + 3
	Dim Wvalues(n) As String
	Wvalues(0) = Last
	For i = 1 To n-2   
		Wvalues(i) = First + i-1
	Next
	Wvalues(n-1) = First
Else
	n = Last - First + 1 
	Dim Wvalues(n) As String
	For i = 0 To n-1   
		Wvalues(i) = First + i
	Next
End If
End Sub

Private Sub init_view
	Dim n As Int
	n = Wvalues.length 
	WHeight = (n + 2)* Wwheelstep 
	sv.Initialize2(WHeight, "sv")
	mp.AddView(sv,0,0,-1,-1)
	sv.Panel.initialize("")
	sv.Enabled = True
	sv.Panel.color = Wlblcolor
	putlabels( n) 
	overlay.initialize("")
	overlay.SetBackgroundImage(LoadBitmap(File.DirAssets,"cover.png"))
	overlay.Gravity = Gravity.FILL
	If des_flag Then ' this is due to a white line on top when using the designer. May need adjustment depending on the display size.
		mp.AddView(overlay,0,-2dip,-1,mp.Height+3dip)
	Else
		mp.AddView(overlay,0,-1dip,-1,-1) 'if the definition is by code, the size of mp is not known yet.
	End If
	tmr.initialize("tmr", Wdelay)
	tmr.Enabled = False
End Sub

' Returns the Wheel object
Sub AsView As View
    Return mp
End Sub

Private Sub putlabels(n As Int)
For i = 0 To n-1
	lbw.initialize("")
	lbw.Text = Wvalues(i) 
	lbw.textcolor = Wtextcolor
	lbw.color = Wlblcolor
	lbw.textsize = Wtextsize
	lbw.Gravity = Wlblgravity
	lbw.Typeface = wtf
	sv.Panel.AddView(lbw , 0, Wwheelstep*(i +1) ,sv.Panel.Width, Wwheelstep)
Next
End Sub

'Set the wheel to the required value by its index.
Public Sub SetByIndex(index As Int)
newposition = index * Wwheelstep 
tmr.Enabled = True
End Sub

'Set the wheel to the required value by the value itself.
Public Sub SetByValue(Value As String)
For i = 0 To Wvalues.Length -1
If Value = Wvalues(i) Then
	SetByIndex(i)
	Return
End If
Next
End Sub

' Sets the background color of the wheel.
Public Sub SetColor(color As Int)
Wlblcolor = color
putlabels(Wvalues.Length)
End Sub

' Sets the text color of the wheel.
Public Sub SetTextColor(color As Int)
Wtextcolor = color
putlabels(Wvalues.Length)
End Sub

' Sets the text size of the wheel.
Public Sub SetTextSize(Size As Int)
Wtextsize = Size
putlabels(Wvalues.Length)
End Sub

' Sets the gravity of the wheel (use left , center or right)
Public Sub SetGravity(Gr As Int)
Wlblgravity = Gr
putlabels(Wvalues.Length)
End Sub

'Sets the typeface of the wheel
Public Sub SetTypeface(tf As Typeface)
wtf = tf
putlabels(Wvalues.Length)
End Sub

' Sets several appearance parameters of the wheel.
Public Sub SetAppearance(labelcolor As Int, textcolor As Int, textsize As Int, lblgravity As Int)
Wlblcolor = labelcolor
Wtextcolor = textcolor
Wtextsize = textsize
Wlblgravity = lblgravity
putlabels(Wvalues.Length)
End Sub

' Sets the delay in ms until the wheel settles.
Public Sub SetDelay(Delay As Int)
Wdelay = Delay
tmr.Interval = Wdelay
End Sub

'Set the wheel to Bottom or Top of the list.
Public Sub FullScroll(Bottom As Boolean)
sv.FullScroll(Bottom)
tmr.Enabled = True
End Sub

' Update the list of values of the wheel, using a list.
Public Sub UpdateList( List1 As List )
SetValuesByList(List1)
Reset
End Sub

' Update the list of values of the wheel, using a string array.
Public Sub UpdateArray(values() As String)
SetValuesByArray(values)
Reset	
End Sub

' Update the list of values of the wheel, using a string array of two numbers - first and last.
Public Sub UpdateInt(First As Int, Last As Int)
SetValuesByInt(First,Last)
Reset
End Sub

'To change the bitmap used as cover on top of the wheel
Public Sub SetCover(dir As String, filename As String)
overlay.SetBackgroundImage(LoadBitmap(dir , filename))
End Sub

'To change the height of the internal labels
Public Sub SetStep(wheelstep As Int)
Wwheelstep = wheelstep
putlabels(Wvalues.Length)
End Sub

Private Sub Reset
Dim n As Int
n = Wvalues.Length
WHeight = (n + 2)* Wwheelstep 
sv.Panel.Height = WHeight
putlabels( n) 
End Sub

Public Sub ReadWheel As String 
Return Wvalues(newposition/Wwheelstep)
End Sub


Private Sub sv_ScrollChanged(Position As Int)
Dim y As Double
y = Position
If Wcyclic Then
	If Position > WHeight - 3.4 * Wwheelstep  Then
	 	newposition =  Wwheelstep  
		sv.ScrollPosition = newposition
	Else If Position <  0.6 * Wwheelstep   Then
	 	newposition = WHeight - 3.6 * Wwheelstep
		sv.ScrollPosition = newposition
	Else 
		y = Position
		newposition = Wwheelstep * Floor(y/Wwheelstep + 0.5)
	End If
Else
	newposition = Wwheelstep * Floor(y/Wwheelstep + 0.5) 
End If
' this event can be included but is not needed for just reading the wheel.
'If  SubExists( Wmodule, WEventName & "_ScrollChanged") Then
'	CallSub2(Wmodule, WEventName  & "_ScrollChanged", Position)				
'End If				
tmr.Enabled = True
End Sub

Private Sub tmr_tick
sv.ScrollPosition = newposition
tmr.Enabled =  False
If SubExists(Wmodule, WEventName & "_Roll") Then
  CallSub2(Wmodule,WEventName & "_Roll",Wvalues(newposition/Wwheelstep))	
End If
End Sub