import requests

from python_version.config import API_ENDPOINT

API_CREATE_OP_ENDPOINT = f"{API_ENDPOINT}/op/create/"


def api_create_ops(data_list: list) -> int:
    response = requests.post(API_CREATE_OP_ENDPOINT, json=data_list)
    return response.status_code
