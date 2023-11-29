#!/bin/bash

# Configurations 
# ===================================================================================
postgreSQL_version="12"
# Path to the postgresql.config file 
postgresql_config_path="..."

set_wal_level="wal_level = replica"
set_archive_mode="archive_mode = on"

# Checks to see if the WAL file already exists in the archive, and if it doesn't, it copies the WAL file to the archive 
# %p is replaced by the path name of the file to archive, while %f is replaced onlyy by the file name. 
# The path name is relatie to the current working director. i.e., the cluster's data directory 
# NOTE: have to make sure that the cp command returns zero exit status if and only if it succeeds. 
# PostgreSQL will assume that the file has been succesffully archived, and will remove or recycle it. However, 
# a nonzero status tells PostgreSQL that the file was not archived; it will try periodically until it succeeds 
set_archive_command="archive_command = 'test ! -f WAL_backup/%f && cp %p WAL_backup/%f'"

# Forces backup of WAL file after a certain amount of time (in seconds). Usually, archive_command is only invoked on completed WAL file (16MB)
set_archive_timeout="archive_timeout = 60" 
# ===================================================================================


# Creates a directory that stores the backup WAL (Write Ahead Logging) files 
mkdir WAL_backup 

# Change permission to allow user postgresql to write to the created direvtory
sudo chown postgres:postgres WAL_backup

# These commands exist in the postgreSQL config, but they are commented out. 
echo "$set_wal_level" >> $postgresql_config_path 
echo "$set_archive_mode" >> $postgresql_config_path
echo "$set_archive_command" >> $postgresql_config_path 
echo "$set_archive_timeout" >> $postgresql_config_path 

# Restart the postgresql.config file
sudo systemctl restart postgresql@$postgreSQL_version-main




