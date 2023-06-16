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

' MsgBox "Creating file..."
'Path and name for the *.csv -File
path = "C:\Users\Dell\Downloads\sed_test_script.csv"

'Create FileSystemObject and *.csv file if it not exist:
Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FileExists(path) Then
	fso.CreateTextFile(path)
Else
	MsgBox "File already exist:" & vbCrLf & path
	Exit Function
End If


' MsgBox "Opening file for writing..."
'Create File-Object and open this File
Set f = fso.GetFile(path)
'iomode = 2, Writing
'format = -2, TristateUseDefault
Set ts = f.OpenAsTextStream(2,-2)
'*.csv file is now ready for Writing

' MsgBox "End of code..."