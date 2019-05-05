#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> Instalando MariaDB"
    mysql_install_db > /dev/null 2>&1
    echo "=> Instalacion completada!"
    /crear_usuario.sh
else
    echo "=> Usando un volumen existente de MariaDB"
fi

exec mysqld_safe
