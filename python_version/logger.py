import logging
import os
from logging.handlers import TimedRotatingFileHandler

from python_version.config import LOG_FILE_NAME, BACKUP_COUNT


def instantiate_logger():
    # Create a logger and add the file handler
    logger = logging.getLogger("task_logger")
    logger.setLevel(logging.INFO)
    logger.propagate = (
        False  # Prevent log messages from being passed to the root logger
    )
    # Create the log file if it doesn't exist
    if not os.path.exists(LOG_FILE_NAME):
        open(LOG_FILE_NAME, "a").close()

    # Create a timed rotating file handler
    file_handler = TimedRotatingFileHandler(
        LOG_FILE_NAME,
        when="midnight",
        interval=1,
        backupCount=BACKUP_COUNT,
    )
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(
        logging.Formatter("%(asctime)s %(levelname)s: %(message)s")
    )

    logger.addHandler(file_handler)

    return logger
