# import json
# import logging
#
# import pythoncom
# from flask import Flask, request, jsonify
#
# from python_version.main import ScadaClient
#
# app = Flask(__name__)
#
# logging.basicConfig(
#     level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
# )
# logger = logging.getLogger(__name__)
#
# pythoncom.CoInitialize()
#
# @app.route("/api/v1/operational-parameters", methods=["GET"])
# def get_data():
#     """
#     Example curl:
#     curl "http://localhost:5000/api/v1/operational-parameters?tags=Power&tags=Flow&tags=Pressure&tags=Level&archive_name=Hourly&start_datetime=2023-06-16 10:56:00.000&end_datetime=2023-06-16 11:00:00.000"
#     """
#
#     # Get query parameters from the request URL
#     tags = request.args.getlist("tags")
#     archive_name = request.args.get("archive_name")
#     start_datetime = request.args.get("start_datetime")
#     end_datetime = request.args.get("end_datetime ")
#
#     logger.info({""})
#
#
#     try:
#         # Get data directly from scada / wincc
#         scada_client = ScadaClient()
#         response = scada_client(
#             tags=tags,
#             archive_name=archive_name,
#             start_datetime=start_datetime,
#             end_datetime=end_datetime,
#         )
#
#         scada_client.close_connection()
#
#     except Exception as e:
#         # Log any exceptions that occur
#         logger.exception(f"An error occurred: {str(e)}")
#         return jsonify({"error": "An error occurred"}), 500
#
#     logger.info(f"Response: {json.dumps(response, indent=4)}")
#     return jsonify(response)
#
#
# if __name__ == "__main__":
#     app.run()
