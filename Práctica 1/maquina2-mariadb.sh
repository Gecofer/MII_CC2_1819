#!/bin/bash

# Creación de la máquina virtual 2 para BD
echo " ------ Creación de la máquina virtual para BD ------ "
IP2=$(az vm create --resource-group myResourceGroup-eastus --name MV2-database --image UbuntuLTS --admin-username gemazure --generate-ssh-keys --storage-sku Standard_LRS --public-ip-address-allocation static --vnet-name MyVnet --subnet mySubnet | jq -r '.publicIpAddress')

# Abrimos el puerto 3306
echo " ------ Abrimos el puerto 3306 ------ "
az vm open-port --port 3306 --resource-group myResourceGroup-eastus --name MV2-database --priority 400

# Una vez creada la máquina virtual, mostramos su nombre y su dirección IP
echo " ------ Datos de la máquina virtual creada para BD ------ "
echo -name: MV2-database
echo -ip: $IP2

# Conectarnos a la máquina virtual
# ssh gemazure@$IP2

# Instalar docker
# sudo apt install docker.io

# Crear imagen para la base de datos
# nano Dockerfile
# nano ejecutar.sh
# nano crear_usuario.sh

# Nos creamos el contenedor
# sudo docker build -t gema/mariadb .
# sudo docker run -d -p 3306:3306 -e MARIADB_PASS="mypass" gema/mariadb

# Y nos vamos a Owncloud y ponemos
# user: admin
# pass: mypass
# database: prueba
# host: $IP2:3306

# Para comprobar conexión
# mysql -u admin -p prueba -h 40.114.73.242 -P 3306
# y meto la contraseña "mypass"
# SELECT User FROM mysql.user;
# show databases;
# show tables;
# select * from oc_users;
