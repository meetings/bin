#!/bin/sh
ssh myssy.dicole.com /usr/local/mbin/backup/dump_remote_mysql_to_dated_file
./initialize_db.sh
