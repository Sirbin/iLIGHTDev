Type=Class
Version=4.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
'Class module
'Events declaration
#Event: ValueChanged(Value As Int, UserChanged As Boolean)

Sub Class_Globals
	Private first As Boolean = True
	Private Cwith As Int
	Private cnvs As Canvas
	Private difbase(4),difside(4), ds  As Float 
	Private cx,cy,S, resbase(),resside(), rescnt() As Int
	Private maxv, position As Double
	Private basecolor,sliderside,slidercnt  As Int
	Private Cwith, Textcolor, Textsize As Int
	Public NONE As Int = 0
	Public SHORT_KNOB As Int = 1
	Public LONG_KNOB As Int = 2
	Private Clabel As Label
	Private CModule As Object
	Private  Cbase As Panel	
	Private basepath, slidepath As Path
	Private R As Reflector
	Private Event As String
End Sub

'Initializes the object. For module put Me.
'Public Sub Initialize(Module As Object, Eventname As String, WithButton As Boolean)
Public Sub Initialize(Module As Object, Eventname As String)
	CModule = Module
	Event = Eventname
End Sub


'If you create the object by code, not by the designer, use this sub after initialization.
'If you want to show knob on the slider - put WithKnob as 1 (SHORT_KNOB) or 2 (LONG_KNOB).
Public Sub CodeCreateView(Width As Int ,Height As Int, MaxValue As Int, WithKnob As Int)
	maxv = MaxValue
	Cbase.Initialize("Cbase")
	Cwith = WithKnob
	ContinueCreation
End Sub

'This sub is called by the Designer when the view is defined as custom view.
Private Sub DesignerCreateView(base As Panel, Lbl As Label, Props As Map)'ignore
	S = Min(Lbl.Width, Lbl.Height)
	ds = 0.005 * S
	Cbase.Initialize("Cbase")
	base.AddView(Cbase,0,0,S,S)
	maxv = Lbl.text
	Cwith =  Lbl.Tag
	ContinueCreation
End Sub

Private Sub ContinueCreation
				      	' These are the default colors and text size
	setColors(Colors.Gray, Colors.DarkGray,Colors.LightGray, Colors.white, 24)
End Sub

'Controls the colors and text size
Public Sub setColors(base_color As Int,slider_color_side As Int,slider_color_cnt As Int, Text_color As Int, Text_size As Int)
	basecolor = base_color
	sliderside = slider_color_side
	slidercnt = slider_color_cnt
	Textcolor = Text_color
	Textsize = Text_size

	resbase = ParseColor(basecolor)
				' from basecolor in the side to white in center
	difbase(1) = (255-resbase(1))/10 
	difbase(2) = (255-resbase(2))/10
	difbase(3) = (255-resbase(3))/10

	rescnt = ParseColor(slidercnt)
	resside = ParseColor(sliderside)
				' from slidebase in the side to slidecnt in center
	difside(1) = (rescnt(1)-resside(1))/10 
	difside(2) = (rescnt(2)-resside(2))/10
	difside(3) = (rescnt(3)-resside(3))/10

End Sub

'Returns the panel
Public Sub AsView As View
	Return Cbase
End Sub

Private Sub Cbase_Touch (Action As Int, X As Float, Y As Float) As Boolean
	Dim teta As Float = RtoAngle(X,Y)
	If teta > 0 AND teta < 270 Then DrawPosition(teta, True)
	Return True
End Sub

'Sets the circle seek to the required value
'Must be called at least once to display the view.
Public Sub setValue(Value As Double)
	If first Then ' only after the new size of the view is known
		cnvs.Initialize(Cbase)
		R.Target = cnvs
		R.Target = R.GetField("paint")
		R.RunMethod2("setAntiAlias", True, "java.lang.boolean")
		S = Min(Cbase.Width, Cbase.Height)
		ds = 0.005 * S
		cx = S/2
		cy = S/2
		basepath.Initialize(0,S)
		basepath.LineTo(0,0)
		basepath.LineTo(S,0)
		basepath.LineTo(S,S)
		basepath.LineTo(cx,cy)
		basepath.LineTo(0,S)
			
		Clabel.Initialize("")
		Clabel.Color = Colors.Transparent
		Clabel.Textcolor = Textcolor
		Clabel.Textsize = Textsize
		Clabel.Gravity = Gravity.CENTER
		Cbase.AddView(Clabel,cx-S/4,cy,S/2,S/2)
		first = False
	End If
	position = Value
	DrawPosition(Round(Value * 270 / maxv),False)
End Sub

' Returns the current value of the circleseek
Sub getValue As Double
	Return position
End Sub

Private Sub DrawPosition(Angle As Int, userchanged As Boolean)
	DrawBase
	DrawSlider(Angle)
	position = Angle * maxv / 270
	Clabel.Text = NumberFormat(position,0,0)
	Cbase.Invalidate 
	cnvs.RemoveClip
	Dim k As Int = position
	If SubExists(CModule, Event & "_ValueChanged") Then
	  	CallSub3(CModule, Event & "_ValueChanged",k, userchanged )
	End If
End Sub

Private Sub DrawBase
Dim clr As Int
	cnvs.ClipPath(basepath)
	For i = 1 To 10
		clr = Colors.rgb(resbase(1)+i*difbase(1),resbase(2)+i*difbase(2),resbase(3)+i*difbase(3))
		cnvs.DrawCircle(cx, cy, S*0.5 -i*ds, clr, False, 2)
		cnvs.DrawCircle(cx, cy, S*0.4 +i*ds, clr, False, 2)
	Next
End Sub

Private Sub DrawSlider(angle As Float)
	Dim clr As Int
	slidepath.Initialize(0,S)
	If angle > 90 Then slidepath.LineTo(0,0) 
	If angle > 180 Then slidepath.LineTo(S,0) 
	Dim point(2) As Float = PtoR(angle , 2*cx)
	slidepath.LineTo(point(0),point(1))
	slidepath.LineTo(cx,cy)
	cnvs.ClipPath(slidepath)

	For i = 1 To 10  ' Draws the slider circle
		clr = Colors.rgb(resside(1)+i*difside(1),resside(2)+i*difside(2),resside(3)+i*difside(3))
		cnvs.DrawCircle(cx, cy, S*0.5 -i*ds, clr, False, 2)
		cnvs.DrawCircle(cx, cy, S*0.4 +i*ds, clr, False, 2)
	Next
	cnvs.RemoveClip
	Select Cwith
		Case NONE   ' = 0
		
		Case SHORT_KNOB  ' = 1 draws short knob

			Dim p1(2), p2(2), dk  As Float 
			For i = 1 To 10  
				dk = -7+i*0.7
				p1 = PtoR(angle+dk , S*0.5)
				p2 = PtoR(angle+dk , S*0.4)
				clr = Colors.RGB(i*25,i*25,i*25) 'from black to white
				cnvs.DrawLine(p1(0),p1(1),p2(0),p2(1),clr,1)
				p1 = PtoR(angle-dk , S*0.5)
				p2 = PtoR(angle-dk , S*0.4)
				cnvs.DrawLine(p1(0),p1(1),p2(0),p2(1),clr,1)
			Next
			
		Case LONG_KNOB  ' = 2  Arrow knob
			Dim p1(2), dk  As Float 
			cnvs.ClipPath(basepath)
			clr = cnvs.Bitmap.GetPixel(1dip,1dip)
			cnvs.DrawCircle(cx,cy,S*0.4,clr,True,1) ' erase the previous arrow
			For i = 1 To 10  
				dk = -7+i*0.7
				p1 = PtoR(angle+dk , S*0.5)
				clr = Colors.RGB(i*25,i*25,i*25) 'from black to white
				cnvs.DrawLine(p1(0),p1(1),cx,cy,clr,1)
				p1 = PtoR(angle-dk , S*0.5)
				cnvs.DrawLine(p1(0),p1(1),cx,cy,clr,1)
			Next
			
		Case Else
		
	End Select
End Sub

Private Sub PtoR(alfa As Float, Rad As Float) As Float()
	Dim point(2) As Float
	point(0) = cx + Rad * SinD(alfa - 135)
	point(1) = cy - Rad * CosD(alfa - 135) 
	Return point
End Sub

'Returns just the angle.
Private Sub RtoAngle(X As Float, Y As Float) As Float
	Dim teta As Float
	If Y <> 0 Then
		teta = ATan2D((X-cx),(cy-Y)) + 135
	Else
		If (X-cx) > 0 Then teta = 235 Else teta = 45
	End If
	Return teta
End Sub

'Returns a Int array of the 4 parameters of a color :
'Alfa, R ,G, B
Private Sub ParseColor(clr As Int) As Int()
	Dim res(4) As Int
	res(0) = Bit.UnsignedShiftRight(Bit.AND(clr, 0xff000000), 24) ' alfa
	res(1) = Bit.UnsignedShiftRight(Bit.AND(clr, 0xff0000), 16)   ' R
	res(2) = Bit.UnsignedShiftRight(Bit.AND(clr, 0xff00), 8)      ' G
	res(3) = Bit.AND(clr, 0xff)  ' B
	Return res
End Sub


