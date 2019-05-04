#!/bin/bash

# Creación de la máquina virtual 1 para Owncloud
# Obtenemos la IP
echo " ------ Creación de la máquina virtual para ownCloud ------ "
IP=$(az vm create  --resource-group myResourceGroup-eastus --name MV1-owncloud --image UbuntuLTS --admin-username gemazure --generate-ssh-keys --storage-sku Standard_LRS --public-ip-address-allocation static --vnet-name MyVnet --subnet mySubnet | jq -r '.publicIpAddress')

# Cambiamos el tamaño a la máquina virtual
echo " ------ Cambiando el tamaño a la máquina virtual ------ "
az vm resize --resource-group myResourceGroup-eastus --name MV1-owncloud --size Standard_B1s

# Abrimos el puerto 80
echo " ------ Abrimos el puerto 80 ------ "
az vm open-port --port 80 --resource-group myResourceGroup-eastus --name MV1-owncloud --priority 300

# Una vez creada la máquina virtual, mostramos su nombre y su dirección IP
echo " ------ Datos de la máquina virtual creada para Owncloud ------ "
echo -name: MV1-owncloud
echo -ip: $IP

# Conectarnos a la máquina virtual
# ssh gemazure@$IP

# Instalar docker
# sudo apt install docker.io

# Descargar owncloud y ponerlo en funcionamiento
# sudo docker pull owncloud:latest
# sudo docker run -d -p 80:80 owncloud:latest
