List Stages;

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
'Create Storage Integration object for Azure External Stage'
'-----------------------------------------------------------'
create OR REPLACE storage integration AZURE_INTEGRATION
    type = external_stage
    storage_provider = azure
    azure_tenant_id = 'f9876a8b-216c-423e-9b05-35340e3d5ceb'
    enabled = true
    storage_allowed_locations = ( 'azure://snwflksa.blob.core.windows.net/snwflk-stage-con/inbound/');

-- Storage Blob DAta contributor
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
SHOW STORAGE INTEGRATIONS;
DROP STORAGE INTEGRATION AZURE_INT;
DESCRIBE STORAGE INTEGRATION AZURE_INTEGRATION;

CREATE OR REPLACE STAGE AZURE_STAGE
  URL='azure://snwflksa.blob.core.windows.net/snwflk-stage-con/inbound'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2022-11-02&ss=b&srt=co&sp=rwdlacyx&se=2023-08-30T20:45:16Z&st=2023-08-22T12:45:16Z&spr=https&sig=b28CXL6IxmltRTGICm5jM4hNRQ5LGaC7UjbcK%2BjdG7I%3D');

SHOW STAGES;
DESCRIBE STAGE AZURE_STAGE;
LIST @AZURE_STAGE;

CREATE OR REPLACE TABLE DEV_SCHEMA.EMP_AZURE
(id VARCHAR,
first_name VARCHAR,
last_name VARCHAR,
gender VARCHAR,	
salary VARCHAR);

SELECT * FROM DEV_SCHEMA.EMP_AZURE;
DELETE FROM DEV_SCHEMA.EMP_AZURE WHERE 1=1;

COPY INTO DEV_SCHEMA.EMP_AZURE(ID, FIRST_NAME, LAST_NAME, GENDER, SALARY)
FROM 
(SELECT $1, $2, $3, $4, $5
 FROM '@DEV_SCHEMA.AZURE_STAGE/emp_azure.csv')
FILE_FORMAT = 
    (type='CSV'
    field_delimiter=','
    skip_header=1
    TRIM_SPACE=True
    ENCODING='UTF8'
    SKIP_BLANK_LINES=TRUE);

    --PURGE =TRUE;

SELECT * FROM DEV_SCHEMA.EMP_SNOWFLAKE;



