
# Get the current script directory
import os
import sys
from datetime import datetime

script_dir = os.path.dirname(os.path.abspath(__file__))

# Get the parent directory of the script directory
parent_dir = os.path.dirname(script_dir)

# Add the parent directory to the Python path
sys.path.append(parent_dir)

import win32com.client

from python_version.api import api_create_ops
from python_version.config import (
    SCADA_CONN_STRING,
    DB_CONN_TYPE,
    DB_COMMAND,
    PLANT_ID,
)
from python_version.logger import instantiate_logger

logger = instantiate_logger()

class ScadaClient:
    def __init__(self, connection_string: str):
        self.connection = self.get_connection(connection_string)
        self.initial_results = {}

    def extract_data(
        self, tags: list, archive_name: str, start_datetime: str, end_datetime
    ) -> list:

        try:
            result = {}
            for tag in tags:
                self.build_command_text(
                    tag=tag,
                    archive_name=archive_name,
                    start_datetime=start_datetime,
                    end_datetime=end_datetime,
                )
                self.build_command()
                result = self.get_values(tag=tag)

            listified = self.listify_dict(result)
            logger.info(
                {
                    "msg": "Retrieved from scada",
                    "listified": listified,
                }
            )
            return listified
        except Exception as exc:
            logger.exception({"msg": f"Got unexpected error: {str(exc)}"})

    def transform_data(self, data: list):
        """
        We don't need to transform anything currently, but adding
        it here so we can easily implement in the future
        """
        pass

    @staticmethod
    def listify_dict(items: dict):
        """
        Expected format:
            {
                <some_date1>: {
                    "temperature": 18,
                    "flow": 19
                },
                <some_date2>: {
                    "temperature": 19,
                    "flow": 10
                },
            }
        """
        listified_dict = []
        for date_and_time, values in items.items():
            for key, value in values.items():
                listified_dict.append(
                    {
                        "scada_datetime": date_and_time,
                        "plant_id": PLANT_ID,
                        "key": key,
                        "value": value,
                    }
                )
        return listified_dict

    @staticmethod
    def get_connection(connection_string: str):
        """Creates connection object and connect to it."""
        conn = win32com.client.Dispatch(DB_CONN_TYPE)
        conn.ConnectionString = connection_string
        conn.CursorLocation = 3
        conn.Open()
        return conn

    def build_command_text(
        self, tag: str, archive_name: str, start_datetime: str, end_datetime
    ):
        """
        # TODO: Find a more optimal way to query all tags in batch.
        Examples:
            :param start_datetime: 2023-06-16 10:56:00.000
            :param end_datetime: 2023-06-16 10:57:00.000
            :param tags: ["Flow", "Power"]
            :param archive_name: "Hourly". Refer to wincc for available options
        """

        self.command_text = (
            f"Tag:R,'{archive_name}\{tag}',{start_datetime},'{end_datetime}'"
        )

    def build_command(self, conn_type: str = DB_COMMAND):
        self.command = win32com.client.Dispatch(conn_type)
        self.command.CommandType = 1
        self.command.ActiveConnection = self.connection
        self.command.CommandText = self.command_text

    def get_values(self, tag: str):
        rect_set = self.command.Execute()
        rect_set = rect_set[0]
        while not rect_set.EOF:
            # Convert to correct timezone
            date_and_time_in_timezone = datetime.fromtimestamp(
                rect_set.Fields("Timestamp").Value.timestamp()
            )

            formatted_date = date_and_time_in_timezone.strftime(
                "%Y-%m-%d %H:%M:%S"
            )

            if formatted_date not in self.initial_results:
                self.initial_results[formatted_date] = {}

            self.initial_results[formatted_date][tag] = rect_set.Fields(
                "RealValue"
            ).Value
            rect_set.MoveNext()
        return self.initial_results

    def close_connection(self):
        self.connection.Close()
