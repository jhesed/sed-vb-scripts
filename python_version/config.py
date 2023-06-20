# TODO: Move to env variables and secure these info
import os

CONN_STRING = "Provider=WinCCOLEDBProvider.1;Catalog=CC_Analytic_23_06_12_15_28_44R;Data Source=DESKTOP-SCACVHI\\WinCC"
DB_CONN_TYPE = "ADODB.Connection"
DB_COMMAND = "ADODB.Command"

TAGS = ["Power", "Flow", "Pressure", "Level"]

# Configure logging
LOG_FILE_NAME = "C:\\Users\\Dell\\OneDrive\\Documents\\sed\\workspace\\sed-vb-scripts\\python_version\\pl-data-miner.log"
BACKUP_COUNT = 5  # Number of backup log files to keep

# Sleep time before app starts.
# We want to add delay before we run our app, so that scada already generated the data we need
# on that particular minute
DELAY = int(os.getenv("DELAY", 1))
