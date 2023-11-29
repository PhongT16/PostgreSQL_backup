#!/bin/bash

backup_directory="database_backup"
path_to_backup_directory="/../../$backup_directory"


# Create the backup directory
mkdir $backup_directory

# Change Permission to user postgres to have write permission
sudo chown postgres:postgres database_backup


# Perform a physical backup of the database cluster's data files.
# Use postgresql built in pg_basebackup command that performs everything for you
# Replace /path/to/ with the path to your directory.
sudo -u postgres pg_basebackup -D /path/to/database_backup

