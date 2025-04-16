#!/bin/bash 
source db_config.sh
mariadb -u $DB_USER -p$DB_PASS -h $DB_HOST $DB_NAME -e "
DELETE FROM positions WHERE timestamp < NOW() - INTERVAL 7 DAY;
"
