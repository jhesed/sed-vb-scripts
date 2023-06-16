import win32com.client

conn_string = "Provider=WinCCOLEDBProvider.1;Catalog=CC_Analytic_23_06_12_15_28_44R;Data Source=DESKTOP-SCACVHI\\WinCC"

# Create the Connection object and open the connection
conn = win32com.client.Dispatch("ADODB.Connection")
conn.ConnectionString = conn_string
conn.CursorLocation = 3
conn.Open()

# Duration variables
DurationDay = "00"
DurationHour = "01"
DurationMin = "30"
DurationSec = "00"

# Build CommandTextStart
CommandTextStart = "'0000-00-" + DurationDay + " " + DurationHour + ":" + DurationMin + ":" + DurationSec + ".000'"

# Define variables
Archivename = "Hourly"
MeasuringPoint = "Flow"

# Build CommandText
CommandText = "Tag:R,'" + Archivename + "\\" + MeasuringPoint + "'," + CommandTextStart + ",'0000-00-00 00:00:00.000'"

print("CommandText: " + CommandText)

# Create the Command object and set properties
command = win32com.client.Dispatch("ADODB.Command")
command.CommandType = 1
command.ActiveConnection = conn
command.CommandText = CommandText

# Execute the command and retrieve the recordset
recSet = command.Execute()[0]
field_names = [field.Name for field in recSet.Fields]

while not recSet.EOF:
    # Iterate through the field names and values
    for field_name in field_names:
        field_value = recSet.Fields(field_name).Value
        print(f"{field_name}: {field_value}")

    recSet.MoveNext()

# Close the connection
conn.Close()
