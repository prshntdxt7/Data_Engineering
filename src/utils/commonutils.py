import pandas as pd
import configparser
import snowflake.connector
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import serialization

class CommonUtils:
    @staticmethod
    def get_snwflk_ctx(logger, config_file_path):
        config = configparser.ConfigParser()
        config.read(filenames=config_file_path)
        logger.info(f"Reading config at: [{config_file_path}]")

        snwflk = config["SNOWFLAKE"]
        user = snwflk["user"]
        password = snwflk["password"]
        account = snwflk["account"]
        private_key = snwflk["private_key"]
        warehouse = snwflk["warehouse"]
        database = snwflk["database"]
        schema = snwflk["schema"]
        rsa_key_path = snwflk["rsa_key_path"]
        logger.info("printing logging statement")

        with open(rsa_key_path, "rb") as key:
            p_key = serialization.load_pem_private_key(
                key.read(),
                password=None,
                backend=default_backend())

        pkb = p_key.private_bytes(
            encoding=serialization.Encoding.DER,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption())

        ctx = snowflake.connector.connect(
            user=user,
            password=password,
            account=account,
            private_key=pkb,
            warehouse=warehouse,
            database=database,
            schema=schema)

        return ctx

