Option Explicit
Function action

' =================================== OPEN CSV

'Declaration of local Tags
Dim fso 'FileSystemObject
Dim f 'File
Dim ts 'TextStream
Dim path 'Path
Dim StartArchive 'Starttime of Archiving
Dim StopArchive 'Stoptime of Archiving
Dim TimeStamp 'Timestamp for bulding filename

' MsgBox "Setting StartArchive value..."
StartArchive = "2023-06-13 00:00:000"
StopArchive = "2023-06-13 23:59:000"

' MsgBox "Creating file..."
'Path and name for the *.csv -File
path = "C:\Users\Dell\Downloads\sed_test_script.csv"

'Create FileSystemObject and *.csv file if it not exist:
Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FileExists(path) Then
	fso.CreateTextFile(path)
Else
	' TODO: Uncomment on real life
	' MsgBox "File already exist:" & vbCrLf & path
	'Exit Function
End If


' MsgBox "Opening file for writing..."
'Create File-Object and open this File
Set f = fso.GetFile(path)
'iomode = 2, Writing
'format = -2, TristateUseDefault
Set ts = f.OpenAsTextStream(2,-2)
'*.csv file is now ready for Writing


' =================================== CONNECT TO DB

'MsgBox "Starting DB connection..."

Dim Pro 'Provider 
Dim DSN 'Data Source Name 
Dim DS 'Data Source 
Dim ConnString 'Connection String 
Dim MachineNameRT 'Name of the PC from WinCC-RT 
Dim DSNRT 'Data Source Name from WinCC-RT 
Dim Conn 'Connection to ADODB 
Dim RecSet 'RecordSet 
Dim Command 'Query 
Dim CommandText 'Command-Text 
Dim CommandTextStart 'Starttime for SQL-String 
Dim Duration 'Duration of Production-Cycle 
Dim DurationSec 'Duration of Production-Cycle 
Dim DurationMin 'Duration of Production-Cycle 
Dim DurationHour 'Duration of Production-Cycle 
Dim DurationDay 'Duration of Production-Cycle 
Dim Language 'Language Tag
Dim MeasuringPoint 'Measuring point
Dim Archivename 'Archive name


'MsgBox "Setting MachineNameRT..."
Set MachineNameRT = HMIRuntime.Tags("@LocalMachineName")

'MsgBox "Setting DSNRT..."
Set DSNRT = HMIRuntime.Tags("@DatasourceNameRT")

'Preparing the Connection-String 
'First instance of WinCCOLEDB
Pro="Provider=WinCCOLEDBProvider.1;" 
'Name of Runtime-Database
DSN="Catalog=" & DSNRT.Read & ";"
'Data Source 
DS= "Data Source=" & MachineNameRT.Read & "\WinCC" 
'Build the complete String: 
ConnString = Pro + DSN + DS 

'Example output: connStringProvider=WinCCOLEDBProvider.1;Catalog=CC_Analytic_23_06_12_15_28_44R;Data Source=DESKTOP-SCACVHI\WinCC
'MsgBox "Done forming connString" & ConnString

'Make Connection 
Set Conn = CreateObject("ADODB.Connection") 
Conn.ConnectionString = ConnString 
Conn.CursorLocation = 3
Conn.open

'Duration between Start an Stop in seconds: 
Duration = DateDiff ("s",StartArchive,StopArchive)
'Split the Duration in days, hours, minutes and seconds: 
DurationMin = Fix(Duration/60) 
DurationSec = Duration - (DurationMin * 60) 
DurationHour = Fix(DurationMin/60) 
DurationMin = DurationMin -(DurationHour * 60) 
DurationDay = Fix(DurationHour/ 24) 
DurationHour = DurationHour - (DurationDay * 24) 
'Creating leading zeros: 
DurationSec = Right("00" & DurationSec,2) 
DurationMin = Right("00" & DurationMin,2) 
DurationHour = Right("00" & DurationHour,2) 
DurationDay = Right("00" & DurationDay,2)

'Formating Starttime:
'MsgBox "Formatting Starttime..." 
CommandTextStart = "'0000-00-" & DurationDay & " " & DurationHour & ":" & DurationMin & ":" & DurationSec & ".000'" 

'MsgBox "Computing CommandTextStart..." &CommandTextStart
'Building the complete String:
'Pass these as parameters when we're ready
Archivename = "Process Value Archive"
MeasuringPoint = "Flow"
 
'MsgBox "Computing CommandText..."
CommandText="Tag:R,'" & Archivename & "\" & MeasuringPoint & "'," & CommandTextStart & ",'0000-00-00 00:00:00.000'" 
MsgBox "CommandText..." &CommandText

'Create the recordset, read the records and set to first ‘redcordset: 
Set Command = CreateObject("ADODB.Command") 
Command.CommandType = 1 
Set Command.ActiveConnection = Conn 

Command.CommandText=CommandText 

Set RecSet = Command.Execute 

RecSet.MoveFirst
MsgBox "End of code..."

End Function