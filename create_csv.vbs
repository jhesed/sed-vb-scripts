'Declaration of local Tags
Dim fso 'FileSystemObject
Dim f 'File
Dim ts 'TextStream
Dim path 'Path
Dim StartArchive 'Starttime of Archiving
Dim StopArchive 'Stoptime of Archiving
Dim TimeStamp 'Timestamp for bulding filename

' TODO: Original code
'Read Start- and Stoptime of Osmosis
' Set StartArchive = HMIRuntime.Tags("DateTimeLastStart")
' Set StopArchive = HMIRuntime.Tags("DateTimeLastStop")

' If StartArchive.Read = "" Or StopArchive.Read = "" Then
' 	MsgBox "Start- or Stoptime of Archiving is missing"
' 	Exit Function
' End If

' TODO: Me messing around with it.

MsgBox "(1) Setting StartArchive value..."
Set StartArchive = "2023-06-13 00:00:000"

'Generate String for the *.csv filename and replace ":" with 
'"_"
' TimeStamp = FormatDateTime(StartArchive.Read, vbGeneralDate)
TimeStamp = FormatDateTime(StartArchive, vbGeneralDate)

TimeStamp = Replace(TimeStamp,":", "_")


MsgBox "(2) Generating timestamp..."

'Path and name for the *.csv -File
path = "C:\Users\Dell\Downloads\sed_test_script.csv"
MsgBox "(3) Creating file..."

'Create FileSystemObject and *.csv file if it not exist:
Set fso = CreateObject("Scripting.FileSystemObject")
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
'*.csv file is now ready for Writing

MsgBox "(4) End of code..."