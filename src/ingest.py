import pandas as pd
import os, shutil
from datetime import datetime, timezone
import configparser
import argparse
from utils.commonutils import CommonUtils
from utils.logger import AppLogger
from utils.constants import Constants

if __name__ == '__main__':
    job_run_id = int(datetime.now(tz=timezone.utc).timestamp() * 1000)
    parser = argparse.ArgumentParser()
    parser.add_argument('-j', '--job_name', help='valid batch job_name', type=str, required=True)

    args = vars(parser.parse_args())
    job_name = args["job_name"]

    config = configparser.ConfigParser()
    config.read(filenames=Constants.config_file_path)

    common = config["COMMON"]
    logs_dir = common["logs_dir"]
    ingestion_type = common["ingestion_type"]

    logs_dir = logs_dir + ingestion_type
    logs_file_name = job_name + "_" + str(datetime.now().strftime("%Y%m%d%H%M%S")) + ".log"
    logs_path = logs_dir + logs_file_name
    if os.path.exists(logs_dir):
        shutil.rmtree(logs_dir)
    os.makedirs(logs_dir)

    logger = AppLogger.get_logger(__name__, logs_path)
    logger.info(f"Logs_Path=[{logs_path}]")

    ctx = CommonUtils.get_snwflk_ctx(logger, Constants.config_file_path)
    logger.info("Snowflake Connection Established !")

    df = pd.read_sql_query(("SELECT * FROM JOB_PARAMS"), ctx)
    logger.info(df)



