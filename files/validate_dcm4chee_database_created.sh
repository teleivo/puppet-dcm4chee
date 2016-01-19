#!/usr/bin/env bash

# usage is: validate_dcm4chee_database_created.sh database_name database_table_to_check database_port

DBNAME=$1
if [ -z $DBNAME ]; then
    echo 'DBNAME not specified'
    exit 2
fi
CHECK_TABLE_NAMED=$2
if [ -z $CHECK_TABLE_NAMED ]; then
    echo 'CHECK_TABLE_NAMED not specified'
    exit 2
fi
DBPORT=$3
if [ -z $DBPORT ]; then
    echo 'DBPORT not specified'
    exit 2
fi

result=$(psql -tq --dbname $DBNAME -p $DBPORT  -c "SELECT EXISTS (
    SELECT 1
    FROM   pg_catalog.pg_class c
    JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE  n.nspname = 'public'
    AND    c.relname = '${CHECK_TABLE_NAMED}'
    AND    c.relkind = 'r'
);")

if [ $? -eq 0 ] && [ $result == 't' ]; then
    echo "table ${CHECK_TABLE_NAMED} exists in db ${DBNAME}"
    exit 0
else
    echo "table ${CHECK_TABLE_NAMED} does not exists in db ${DBNAME}"
    exit 1
fi

