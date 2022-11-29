#!/bin/bash
dbname=$1
mysql -e "UPDATE ${dbname}.sys_user set password = '', inv_secret = '';"

mysql -e "DROP DATABASE miner_data;"
mysql -e "CREATE DATABASE miner_data;"
mysql -e "GRANT ALL ON miner_data.* TO miner@'*' IDENTIFIED BY 'miner';"

#for table in `mysql -B -N -e "SHOW TABLES;" "$dbname"`
#do 
#  mysql -e "RENAME TABLE $dbname.$table to miner_data.$table;"
#done

mysql -e "RENAME TABLE ${dbname}.sys_user to miner_data.user;"
mysql -e "RENAME TABLE ${dbname}.dicole_events_event to miner_data.meeting;"
mysql -e "RENAME TABLE ${dbname}.dicole_events_user to miner_data.meeting_participant;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_draft_participant to miner_data.meeting_draft_participant;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_matchmaker to miner_data.matchmaker;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_matchmaker_url to miner_data.matchmaker_url;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_matchmaking_event to miner_data.matchmaking_event;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_partner to miner_data.partner;"
mysql -e "RENAME TABLE ${dbname}.dicole_meetings_trial to miner_data.trial;"

mysql -e "DROP DATABASE ${dbname};"
