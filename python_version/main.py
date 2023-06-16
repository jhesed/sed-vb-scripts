import json
from datetime import datetime

import win32com.client

from python_version.config import CONN_STRING, DB_CONN_TYPE, DB_COMMAND, TAGS


class ScadaClient:
    def __init__(self):
        self.connection = self.get_connection()

    def __call__(
        self, tags: list, archive_name: str, start_datetime: str, end_datetime
    ):
        self.merged_result = {}

        for tag in tags:
            self.build_command_text(
                tag=tag,
                archive_name=archive_name,
                start_datetime=start_datetime,
                end_datetime=end_datetime,
            )
            self.build_command()
            result = self.get_values(tag=tag)

        return result

    @staticmethod
    def get_connection(connection_string: str = CONN_STRING):
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
            date_and_time = rect_set.Fields("Timestamp").Value
            date_and_time_in_timezone = datetime.fromtimestamp(
                rect_set.Fields("Timestamp").Value.timestamp()
            )

            formatted_date = date_and_time_in_timezone.strftime(
                "%Y-%m-%d %H:%M:%S.%f"
            )

            if formatted_date not in self.merged_result:
                self.merged_result[formatted_date] = {}

            self.merged_result[formatted_date][tag] = rect_set.Fields(
                "RealValue"
            ).Value
            rect_set.MoveNext()
        return self.merged_result

    def close_connection(self):
        self.connection.Close()


if __name__ == "__main__":
    scada_client = ScadaClient()
    result = scada_client(
        tags=TAGS,
        archive_name="Hourly",
        start_datetime="2023-06-16 10:56:00.000",
        end_datetime="2023-06-16 11:00:00.000",
    )
    print(json.dumps(result, indent=2))
    scada_client.close_connection()
