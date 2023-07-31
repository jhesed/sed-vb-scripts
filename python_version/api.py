from typing import Tuple

import requests

from python_version.config import API_ENDPOINT, API_KEY, API_SECRET
from python_version.logger import instantiate_logger
from python_version.security import generate_signature

API_CREATE_OP_ENDPOINT = f"{API_ENDPOINT}/create-plant-parameters"


logger = instantiate_logger()


def api_create_ops(data_list: list) -> Tuple[int, str]:
    signature = generate_signature(api_secret=API_SECRET, parameters=data_list)
    logger.info(
        {
            "msg": "Sending request",
            "signature": signature,
            "parameters": data_list,
        }
    )
    response = requests.post(
        API_CREATE_OP_ENDPOINT,
        json=data_list,
        headers={"x-api-key": API_KEY, "signature": signature},
    )
    return response.status_code, response.text
