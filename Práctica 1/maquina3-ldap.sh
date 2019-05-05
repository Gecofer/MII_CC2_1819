#!/bin/bash

# Creación de la máquina virtual 3 para LDAP
# Obtenemos la IP
echo " ------ Creación de la máquina virtual para OpenLDAP ------ "
IP3=$(az vm create --resource-group myResourceGroup-eastus --name MV3-ldap --image UbuntuLTS --admin-username gemazure --generate-ssh-keys --storage-sku Standard_LRS --public-ip-address-allocation static --vnet-name MyVnet --subnet mySubnet| jq -r '.publicIpAddress')

# Cambiamos el tamaño a la máquina virtual
echo " ------ Cambiando el tamaño a la máquina virtual ------ "
az vm resize --resource-group myResourceGroup-eastus --name MV3-ldap --size Standard_B1s

# Abrimos el puerto 389 y 636
echo " ------ Abrimos el puerto 389 y 636 ------ "
az vm open-port --port 389 --resource-group myResourceGroup-eastus --name MV3-ldap --priority 400
az vm open-port --port 636 --resource-group myResourceGroup-eastus --name MV3-ldap --priority 500

# Una vez creada la máquina virtual, mostramos su nombre y su dirección IP
echo " ------ Datos de la máquina virtual creada para Owncloud ------ "
echo -name: MV3-ldap
echo -ip: $IP3

# Conectarnos a la máquina virtual
# ssh gemazure@$IP3

# Instalar docker y ldap
# sudo apt install docker.io
# sudo apt-get update
# sudo apt install ldap-utils

# Nos descargamos openldap
# sudo docker pull osixia/openldap
# sudo docker run -d -p 389:389 --name ldap -t osixia/openldap

# Crear fichero para el usuario y el grupo de usuario
# nano gema.ldif

# Añadir usuario a LDAP
# ldapadd -H ldap://$IP3 -x -D "cn=admin,dc=example,dc=org" -w admin -c -f gema.ldif
# ldapadd -H ldap://40.76.48.185 -x -D "cn=admin,dc=example,dc=org" -w admin -c -f gema.ldif

# Cambiar la contraseña
# ldappasswd -s admin -W -D "cn=admin,dc=example,dc=org" -x "cn=gema,ou=users,dc=example,dc=org"
# Ahora es gema-admin

# Añadir otro usuario
# antonio.ldif
# ldapadd -H ldap://40.76.48.185 -x -D "cn=admin,dc=example,dc=org" -w admin -c -f antonio.ldif
# ldappasswd -s admin -W -D "cn=admin,dc=example,dc=org" -x "cn=antonio,ou=users,dc=example,dc=org"
# Ahora es antonio-admin
