import hashlib
import hmac
import json


def generate_signature(api_secret, parameters):
    """
    Generate a signature for parameters using HMAC-SHA256 algorithm.

    Parameters:
        api_secret (str): Your API secret.
        parameters (dict): The API parameters as a dictionary.

    Returns:
        str: The generated signature.
    """
    # Sort the parameters alphabetically by keys and convert them to a JSON string
    sorted_params_str = json.dumps(
        parameters, separators=(",", ":"), sort_keys=True
    )

    # Convert the API secret to bytes (required by hmac.new)
    api_secret_bytes = bytes(api_secret, "utf-8")

    # Calculate the HMAC-SHA256 signature
    signature = hmac.new(
        api_secret_bytes, sorted_params_str.encode("utf-8"), hashlib.sha256
    ).hexdigest()

    return signature


def is_valid_signature(submitted_signature, api_secret, parameters):
    # 1. Compute signature based on my copy of api_secret
    expected_signature = generate_signature(api_secret, parameters)

    # 2. Compare submitted_signature with my computed signature
    # 2.1. If equal, the client's signature is valid -- return True
    # 2.2. If not, invalid signature, return False
    if expected_signature == submitted_signature:
        return True
    return False
