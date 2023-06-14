Function WriteArchiveValueToCSV (Archivename, MeasuringPoint)

    '############################################1. Step: Create .csv-File############################################
    'Declaration of local Tags
    Dim fso 			'FileSystemObject
    Dim f   			'File
    Dim ts  			'TextStream
    Dim path 			'Path
    Dim StartArchive	'Starttime of Archiving
    Dim StopArchive		'Stoptime of Archiving
    Dim TimeStamp 		'Timestamp for bulding filename
    
    'Read Start- and Stoptime of Osmosis
    Set StartArchive = HMIRuntime.Tags("DateTimeLastStart")
    Set StopArchive = HMIRuntime.Tags("DateTimeLastStop")
    If StartArchive.Read = "" Or StopArchive.Read = "" Then
        MsgBox "Start- or Stoptime of Archiving is missing"
        Exit Function
    End If
    'Generate String for the CSV-Filename and replace ":" with "_"
    TimeStamp = FormatDateTime(StartArchive.Read, vbGeneralDate)
    TimeStamp = Replace(TimeStamp,":", "_")
    
    'Path and name for the CSV-File
    path = "C:\Temp\Osmosis_" & TimeStamp & "_" & MeasuringPoint & ".csv"
    
    'Create FileSystemObject And CSV-File if it not exist:
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    If Not fso.FolderExists("C:\Temp") Then
        fso.CreateFolder ("C:\Temp")
    End If
    
    If Not fso.FileExists(path) Then
        fso.CreateTextFile(path)
     Else
        MsgBox "File already exist:" & vbCrLf & path
        Exit Function
    End If
    
    'Create File-Object and open this File
    Set f = fso.GetFile(path)
    'iomode = 2, Writing
    'format = -2, TristateUseDefault
    Set ts = f.OpenAsTextStream(2,-2)
    'CSV-File is now ready for Writing
    
    
    '########################################2.Step: Connecting with WinCC Database#############################################
    
    Dim Pro 				'Provider 
    Dim DSN 				'Data Source Name 
    Dim DS 					'Data Source 
    Dim ConnString 			'Connection String 
    Dim MachineNameRT		'Name of the PC from WinCC-RT 
    Dim DSNRT 				'Data Source Name from WinCC-RT 
    Dim Conn 				'Connection to ADODB 
    Dim RecSet 				'RecordSet 
    Dim Command		 		'Query 
    Dim CommandText 		'Command-Text 
    Dim CommandTextStart 	'Starttime for SQL-String 
    Dim Duration 			'Duration of Production-Cycle 
    Dim DurationSec 		'Duration of Production-Cycle 
    Dim DurationMin 		'Duration of Production-Cycle 
    Dim DurationHour		'Duration of Production-Cycle 
    Dim DurationDay 		'Duration of Production-Cycle 
    Dim Language			'Language tag
    
    'Attention: Tag-Archiving is based on UTC, that means the timestamp 
    'of a Tag is in UTC !
    'Read the name of the PC-Station and the DSN-Name from WinCC-RT 
    Set MachineNameRT = HMIRuntime.Tags("@LocalMachineName")
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
    
    'Make Connection 
    Set Conn = CreateObject("ADODB.Connection") 
    Conn.ConnectionString = ConnString 
    Conn.CursorLocation = 3
    Conn.open 
    
    'Preparing query 
    'Format of Command.CommandText 
    '"Tag:R,1,'2009-01-20 11:15:23.000',"'2009-01-20 13:26:45.000'" 
    ' | | | 		|						 | 
    ' | | | 		---- Starttime (UTC)	 ------ Endtime (UTC) 
    ' | | ----- Value-ID or Tagname 	
    ' | ------- Read 
    ' ---------- Command for a Tag
    
    'Duration between Start an Stop in seconds: 
    Duration = DateDiff ("s",StartArchive.Read,StopArchive.Read)
    'Split the Duration in days, hours, minutes and seconds: 
    DurationMin  = Fix(Duration/60) 
    DurationSec  = Duration - (DurationMin * 60) 
    DurationHour = Fix(DurationMin/60) 
    DurationMin  = DurationMin -(DurationHour * 60) 
    DurationDay  = Fix(DurationHour/ 24) 
    DurationHour = DurationHour - (DurationDay * 24) 
    'Creating leading zeros: 
    DurationSec  = Right("00" & DurationSec,2) 
    DurationMin  = Right("00" & DurationMin,2) 
    DurationHour = Right("00" & DurationHour,2) 
    DurationDay  = Right("00" & DurationDay,2) 
    'Formating Starttime: 
    CommandTextStart= "'0000-00-" & DurationDay & " " & DurationHour & ":" & DurationMin & ":" & DurationSec & ".000'" 
    'Building the complete String: 
    CommandText="Tag:R,'" & Archivename & "\" & MeasuringPoint & "'," & CommandTextStart & ",'0000-00-00 00:00:00.000'" 
    'MsgBox "CommandText for SQL-Satement: " & vbCrLf & CommandText
    
    'Create the recordset, read the records and set to first redcordset: 
    Set Command = CreateObject("ADODB.Command") 
    Command.CommandType = 1 
    Set Command.ActiveConnection = Conn 
    Command.CommandText=CommandText 
    Set RecSet = Command.Execute 
    RecSet.MoveFirst 
    
    'write recordsets To CSV-File 
    'Header in CSV-File 
    Language = HMIRuntime.Language
    Select Case Language
        Case 1031		'German = 1031	
            ts.WriteLine ("Tag-Name;ValueID;Datum/Zeit;Prozesswert")
        Case 1033		'English = 1033
            ts.WriteLine ("Tag-Name;ValueID;Date/Time;Process-Value")
    End Select
    
    Do While Not RecSet.EOF 
        ts.WriteLine (MeasuringPoint & ";" & RecSet.Fields("ValueID").Value & ";" & RecSet.Fields("TimeStamp").Value & ";" & RecSet.Fields("RealValue").Value) 
        RecSet.MoveNext 
    Loop 
    
    Select Case Language
        Case 1031		'German = 1031	
            MsgBox "Schreiben der Datei"  & vbCrLf & "C:\Temp\Osmosis_" & TimeStamp & "_" & MeasuringPoint & ".csv" & vbCrLf & "erfolgreich!"
        Case 1033		'English = 1033
            MsgBox "Writing of File"  & vbCrLf & "C:\Temp\Osmosis_" & TimeStamp & "_" & MeasuringPoint & ".csv" & vbCrLf & "successful!"		
    End Select
    
    ' Close all
    ts.Close 
    RecSet.Close 
    Set ReCset=Nothing 
    Set Command = Nothing 
    conn.Close 					'Close connection 
    Set Conn = Nothing 
    Set fso = Nothing 
    Set f = Nothing 
    Set ts = Nothing 
    
    End Functi