#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Esperando confirmación del servicio de MariaDB"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MARIADB_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MARIADB_PASS} ] && echo "preset" || echo "random" )
echo "=> Creado usuario"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

echo "========================================================================"
echo "    mysql -u admin -p $PASS -h <host> -P <port>"
echo "========================================================================"

mysqladmin -uroot shutdown
