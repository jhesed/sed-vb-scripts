
' Define the WinCC table control name
Const tableName = "Control1"

' Define the path and filename for the CSV export
Const exportPath = "C:\Users\Dell\Downloads\export.csv"

' Access the WinCC table control
Set tableControl = HMIRuntime.ActiveScreen.ScreenItems(tableName)

' Create a file system object
Set fso = CreateObject("Scripting.FileSystemObject")

' Open the CSV file for writing
Set exportFile = fso.CreateTextFile(exportPath, True)

' Write headers to the CSV file
headerRow = ""
For Each column In tableControl.Columns
    headerRow = headerRow & column.Header.Text & ","
Next
exportFile.WriteLine Left(headerRow, Len(headerRow) - 1)

' Write data rows to the CSV file
For Each row In tableControl.Rows
    rowData = ""
    For Each cell In row.Cells
        rowData = rowData & cell.Text & ","
    Next
    exportFile.WriteLine Left(rowData, Len(rowData) - 1)
Next

' Close the CSV file
exportFile.Close

' Clean up objects
Set exportFile = Nothing
Set tableControl = Nothing
Set fso = Nothing