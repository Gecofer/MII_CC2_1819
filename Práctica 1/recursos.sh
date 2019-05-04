
#!/bin/bash

# Creación del grupo de recursos con localización en el este de EE.UU.
echo " ------ Creación del grupo de recursos ------ "
az group create --name myResourceGroup-eastus --location eastus

# Creación de una red virtual llamada myVnet y una subred llamada mySubnet
echo " ------ Creación de la red virtual ------ "
az network vnet create  --resource-group myResourceGroup-eastus --name myVnet --address-prefix 10.0.0.0/16 --subnet-name mySubnet --subnet-prefix 10.0.1.0/24
