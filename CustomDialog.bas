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
	
	
	
End Sub
Sub PanelloGruppi
	Dim SprinGroups As Spinner
	
	SprinGroups.AddAll(PoliciesMode.StrAddr)
	
	Dim pnl1,pnl2 As Panel
	
	Dim TableGruppi As Table
	pnl1.Initialize("PnlGruppi")
	Dim lv As ListView
	lv.Initialize("")
	
'	Dim m As Map
'	m = DBUtils.ExecuteMap(Main.SQL1,"SELECT Address, Groups ,Groups1 FROM Address where  = ?, array as 
'	DBUtils.
'	DBUtils..ExecuteListView(Main.SQL1, "SELECT Groups , Groups1 FROM Address where Address = ? ", Array As String("0x0013a20040be447f"), 0 ,lv, True)
	
	
'	TableGruppi.Initialize(Me,"TableGroups",4,Gravity.CENTER_HORIZONTAL,True)
'	TableGruppi.AddToActivity(pnl1 , 0, 0, 100%x,100%y)	
'    TableGruppi.SetHeader(Array As String(
'	
	Dim bg,bg1 As ColorDrawable
	bg.Initialize(Colors.Blue,2dip)
	bg1.Initialize(Colors.Green,2dip)
'	Dim ch,ch1 As CheckBox
'	ch.Initialize("Pulsanteall")
'	ch1.Initialize("")
'	ch.Text = "all"
	pnl1.Background = bg
	pnl2.Initialize("Pnl2")
	pnl2.Background = bg1
'	Dim Labell As Label
'	Labell.Initialize("")
'	Labell.Text = "Seleziona"
'	Labell.Color = Colors.Black
	lv.AddSingleLine("qualcosa")
	pnl1.AddView(lv,10dip,50dip,500,300dip)
	
	

End Sub

