import time
from datetime import datetime, timedelta

import pytz

from python_version.api import api_create_ops
from python_version.config import (
    TAGS,
    DELAY,
    REPORT_RANGE_MINS,
    ARCHIVE_TABLE_NAME,
    SCADA_CONN_STRING,
)
from python_version.logger import instantiate_logger
from python_version.scada_client import ScadaClient

logger = instantiate_logger()


def run():
    # Let's wait for Scada to finish its previous executions
    time.sleep(DELAY)

    # Get current datetime in UTC (scada time)
    end_datetime = datetime.now(pytz.utc).replace(second=0, microsecond=0)

    # Get data from the past x minutes
    start_datetime = end_datetime - timedelta(minutes=REPORT_RANGE_MINS)

    # Format the datetime strings
    start_datetime_str = start_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    end_datetime_str = end_datetime.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

    logger.info(
        {
            "msg": "Alive.",
            "start_datetime_str": start_datetime_str,
            "end_datetime_str": end_datetime_str,
        }
    )

    # Step: Establish connection to local scada
    scada_client = ScadaClient(connection_string=SCADA_CONN_STRING)

    # Step: Extract data from local scada
    scada_data = scada_client.extract_data(
        tags=TAGS,
        archive_name=ARCHIVE_TABLE_NAME,
        start_datetime=start_datetime_str,
        end_datetime=end_datetime_str,
    )
    if not scada_data:
        logger.info(
            {
                "msg": "No data received. Not sending to centralized server",
                "scada_data": scada_data,
            }
        )
        return

    logger.info({"msg": "Got data.", "scada_data": scada_data})

    # Step: Transform data (modify function as necessary)
    scada_client.transform_data(scada_data)

    # Step: Send to central scada which will then pass data to eventhub
    status_code, status_text = api_create_ops(data_list=scada_data)
    logger.info(
        {
            "msg": "Got API response",
            "status_code": status_code,
            "status_text": status_text,
        }
    )
    # Step: Close scada connection as it's no longer needed
    scada_client.close_connection()

    """
    Uncomment if we want to send directly to event hub instead of passing data to a central API

    # Step: Establish connection to Azure event hub
    event_hub_client = EventHubClient(
        connection_string=EVENTHUB_CONN_STRING, eventhub_name=EVENTHUB_NAME
    )

    # Step: Send scada data to Event hub
    event_hub_client.send_data_to_eventhub(data=scada_data)
    logger.info({"msg": "Done sending data to event hub", "scada_data": scada_data})
    """


if __name__ == "__main__":
    while True:
        run()
