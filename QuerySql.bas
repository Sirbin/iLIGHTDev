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
Sub Create_Table
	DBUtils.DropTable(Main.SQL1, "Address")
	DBUtils.DropTable(Main.SQL1 , "Groups")
		
	Dim tbl As Map
	tbl.Initialize
		tbl.Put("Key", DBUtils.DB_INTEGER)
		tbl.Put("AddressLux", DBUtils.DB_TEXT)
		tbl.Put("Date", DBUtils.DB_TEXT)
		DBUtils.CreateTable(Main.SQL1 , "Address", tbl , "Key")
		Dim tbl1 As Map
		tbl1.Initialize
		tbl1.Put("Key", DBUtils.DB_INTEGER)
		tbl1.Put("GroupsLux1", DBUtils.DB_TEXT)
		tbl1.Put("GroupsLux2",DBUtils.DB_TEXT)
		tbl1.Put("GroupsLux3",DBUtils.DB_TEXT)
		tbl1.Put("GroupsLux4",DBUtils.DB_TEXT)
		DBUtils.CreateTable(Main.SQL1 , "Groups", tbl1, "Key")
End Sub