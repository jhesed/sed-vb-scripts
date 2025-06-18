import json

from azure.eventhub import EventHubProducerClient, EventData


class EventHubClient:
    def __init__(self, connection_string: str, eventhub_name: str):
        self.producer = self.get_connection(connection_string, eventhub_name=eventhub_name)

    def get_connection(self, connection_string: str, eventhub_name: str):
        return EventHubProducerClient.from_connection_string(
            conn_str=connection_string, eventhub_name=eventhub_name
        )

    def send_data_to_eventhub(self, data: list):
        event_data_batch = self.producer.create_batch()
        event_data_batch.add(EventData(json.dumps(data)))
        self.producer.send_batch(event_data_batch)
