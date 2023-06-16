Sub WriteArchiveMessagesToCSV
'############################################1. Step: Create .csv-File############################################
'Declaration of local Tags
Dim fso 			'FileSystemObject
Dim f   			'File
Dim ts  			'TextStream
Dim path			'path	
Dim StartTime		'Date and Time when writing is triggerd
Dim TimeStamp 		'Timestamp for bulding filename


'Date and Time when writing is triggerd
StartTime = Now
'Generate String for the csv-Filename And Replace ":" With "_"
TimeStamp = FormatDateTime(StartTime, vbGeneralDate)
TimeStamp = Replace(TimeStamp,":", "_")
'Path and name for the CSV-File
path ="C:\Temp\Osmosis_" & TimeStamp & "_Messages.csv"
 
'Create FileSystemObject And CSV-File if it not exist:
Set fso = CreateObject("Scripting.FileSystemObject")

If Not fso.FolderExists("C:\Temp") Then
	fso.CreateFolder ("C:\Temp")
End If

If Not fso.FileExists(path) Then
 	fso.CreateTextFile(path)
 Else
 	MsgBox "File already exist:" & vbCrLf & path
	Exit Sub
End If
'Create File-Object and open this File
Set f = fso.GetFile(path)

Set ts = f.OpenAsTextStream(2,-2)
'iomode = 2, Writing 
'format = -2, TristateUseDefault
'CSV-File is now ready for Writing

'########################################2.Step: Connecting With WinCC Database#############################################
'Declaration of Script Tags
Dim Pro 				'Provider 
Dim DSN 				'Data Source Name 
Dim DS 					'Data Source 
Dim ConnString 			'Connection String 
Dim MachineNameRT		'Name of the PC from WinCC-RT 
Dim DSNRT 				'Data Source Name from WinCC-RT 
Dim Conn 				'Connection to ADODB 
Dim CommandText 		'Command-Text 
Dim SqlSec 				'Duration of Production-Cycle 
Dim SqlMin				'Duration of Production-Cycle 
Dim SqlHour				'Duration of Production-Cycle 
Dim SqlDay 				'Duration of Production-Cycle 
Dim SqlMonth 			'Duration of Production-Cycle 
Dim SqlYear 			'Duration of Production-Cycle
Dim RecSet 				'RecordSet 
Dim Command		 		'Query 
Dim Language			'Language Tag


'Read the name of the PC-Station and the DSN-Name from WinCC-RT 
Set MachineNameRT = HMIRuntime.Tags("@LocalMachineName")
Set DSNRT = HMIRuntime.Tags("@DatasourceNameRT") 
'Preparing the Connection-String 
Pro="Provider=WinCCOLEDBProvider.1;" 'First instance of WinCCOLEDB 
DSN="Catalog=" & DSNRT.Read & ";" 'Name of Runtime-Database 
DS= "Data Source=" & MachineNameRT.Read & "\WinCC" 'Data Source 
'Build the complete String: 
ConnString = Pro + DSN + DS 
'Connection based on ODB-Provider
Set Conn = CreateObject("ADODB.Connection") 
Conn.ConnectionString = ConnString 
Conn.CursorLocation = 3
Conn.open 

'Preparing query 
'Format of Command.CommandText 
'"ALARMVIEWEX:Select * FROM ALGVIEWEXDEU WHERE DateTime>" & StartTime & "And MsgNr < 4 And State = 1"
' | 						| 			|  |					    | 				|
' |							|			|  |						|				---condition3
' | 						| 			| 	---condition1		    ------condition 2			 
' | 						| 			----- condition word
' |							 ------- ViewName for german messages
' ---------- Command for alarmview

'FormatStarttime for SQL-Statement
'Format needed for StartTime: jjjj-mm-dd hh:mm:ss
'Date and time 24 hours  before 
StartTime = DateAdd( "h",- 24,StartTime) 
'Split in years , months , days , hours , minutes ,seconds  
SqlSec = Second(StartTime)
SqlMin = Minute(StartTime)
SqlHour = Hour(StartTime)
SqlDay = Day(StartTime)
SqlMonth = Month(StartTime)
SqlYear = Year (StartTime)
'Creating leading zeroes
SqlSec = Right("00" & sqlSec,2)
SqlMin = Right("00" & sqlMin,2)
SqlHour = Right("00" & sqlHour,2)
SqlDay = Right("00" & sqlDay,2)
SqlMonth = Right("00" & sqlMonth,2)
StartTime = "'" & SqlYear & "-" & SqlMonth & "-" & SqlDay & " " & SqlHour & ":" & SqlMin & ":" & SqlSec & "'"

'Building the complete string
Language = HMIRuntime.Language
Select Case Language
	Case 1031		'German = 1031	
		CommandText = "ALARMVIEWEX:Select * FROM ALGVIEWEXDEU WHERE DateTime >" & StartTime & "AND MsgNr < 4 AND STATE = 1"
		'CommandText = "ALARMVIEW:Select * FROM ALGVIEWDEU WHERE DateTime >" & StartTime & "AND MsgNr < 4 AND STATE = 1" (string for < WinCC V7.2)
	Case 1033		'English = 1033
		CommandText = "ALARMVIEWEX:Select * FROM ALGVIEWEXENU WHERE DateTime >" & StartTime & "AND MsgNr < 4 AND STATE = 1"
		'CommandText = "ALARMVIEW:Select * FROM ALGVIEWENU  WHERE DateTime >" & StartTime & "AND MsgNr < 4 AND STATE = 1" (string for < WinCC V7.2)
End Select

'Create the recordset, read the records and set the first recordset:
Set Command = CreateObject("ADODB.Command")
Command.CommandType = 1
Set Command.ActiveConnection = Conn
Command.CommandText = CommandText
Set RecSet = Command.Execute
RecSet.MoveFirst

'write recordsets To CSV-File 
'Header in CSV-File
Language = HMIRuntime.Language 
Select Case Language
	Case 1031		'German = 1031	
		ts.WriteLine ("Datum/Zeit;Meldenr.;Ereignis;Meldeklasse;Meldetyp") 
	Case 1033		'English = 1033
		 ts.WriteLine ("Date/Time;MsgNr.;Event;Messages Class;Messages Typ")
End Select
'writing recordsets
Do While Not RecSet.EOF 
	ts.WriteLine (RecSet.Fields("DateTime").Value & ";" & RecSet.Fields("MsgNr").Value & ";" & RecSet.Fields("Text1").Value & ";" & RecSet.Fields("Classname").Value & ";" & RecSet.Fields("Typename").Value) 
	RecSet.MoveNext 
Loop 

Select Case Language
	Case 1031		'German = 1031	
		MsgBox "Schreiben der Datei" & vbCrLf & "C:\Temp\Osmosis_" & TimeStamp & "_Messages.csv" & vbCrLf & "erfolgreich!"
	Case 1033		'English = 1033
		 MsgBox "Writing of File" & vbCrLf & "C:\Temp\Osmosis_" & TimeStamp & "_Messages.csv" & vbCrLf & "succesful!"
End Select


' Close all
ts.Close 
RecSet.Close 
Set RecSet=Nothing 
Set Command = Nothing 
conn.Close 					'Close connection 
Set Conn = Nothing 
Set fso = Nothing 
Set f = Nothing 
Set ts = Nothing 

End Sub