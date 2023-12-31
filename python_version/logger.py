import logging
from logging.handlers import TimedRotatingFileHandler

from python_version.config import LOG_FILE_NAME, BACKUP_COUNT


def instantiate_logger():
    # Create a timed rotating file handler
    file_handler = TimedRotatingFileHandler(
        LOG_FILE_NAME, when="midnight", interval=1, backupCount=BACKUP_COUNT
    )
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(
        logging.Formatter("%(asctime)s %(levelname)s: %(message)s")
    )

    # Create a logger and add the file handler
    logger = logging.getLogger("task_logger")
    logger.setLevel(logging.INFO)
    logger.addHandler(file_handler)

    return logger
