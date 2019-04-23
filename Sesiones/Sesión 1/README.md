Asignatura Cloud Computing del Máster en Ingeniería Informática. 

Departamento de Ciencias de la Computación e Inteligencia Artificial.

Universidad de Granada.

<HR>

Profesor: **Francisco Javier Baldán Lozano**

Email: **fjbaldan@decsai.ugr.es**

Tutorías: **Lunes, de 11:00 a 12:00, despacho D31 (4ª planta) Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación (ETSIIT). Se recomienda concretar las citas por correo.**

Material de prácticas de la asignatura: **https://github.com/fjbaldan/PracticasCC**

Francisco Javier Baldán Lozano (fjbaldan@decsai.ugr.es), Febrero 2019

![DICITSlogo](http://sci2s.ugr.es/dicits/images/dicits.png)

Material realizado a partir del trabajo de años anteriores de Manuel Parra & José Manuel Benitez: https://github.com/DiCITS/MasterCienciaDatos2019 & https://github.com/manuparra/PracticasCC

<HR>

# Sesión 1: Microsoft AZURE

Tabla de contenido:

  * [Requisitos iniciales](#requisitos-iniciales)
  * [Registro de alumnos](#registro-de-alumnos)
  * [Comenzando con máquinas virtuales (MV o VM)](#comenzando-con-máquinas-virtuales-MV-o-VM)
  * [Creación del agrupamiento de recursos](#creación-del-agrupamiento-de-recursos)
  * [Creación de una máquina virtual](#creación-de-una-máquina-virtual)
  * [Conéctese a la VM](#conéctese-a-la-vm)
  * [Mercado de imágenes VM](#mercado-de-imágenes-VM)
  * [Máquinas virtuales funcionando](#máquinas-viruales-funcionando)
  * [Características de una máquina virtual](#características-de-una-máquina-virtual)
  * [Parar una máquina virtual](#parar-una-máquina-virtual)
  * [Iniciar una máquina virtual](#iniciar-una-máquina-virtual)
  * [Reiniciar una máquina virtual](#reiniciar-una-máquina-virtual)
  * [Eliminar una máquina virtual](#eliminar-una-máquina-virtual)
  * [Abrir puertos de una máquina virtual](#abrir-puertos-de-una-máquina-virtual)
  * [Ejercicio práctico A (instalación de servicios de forma manual)](#ejercicio-práctico-a-instalación-de-servicios-de-forma-manual)
  

# Empezando con servicios de Cloud Computing: 

## Requisitos iniciales

- Tener cuenta de correo de alumno de la universidad.
- Conocimientos básicos del SHELL.
- Conceptos básicos de Cloud y Máquinas Virtuales.

## Registro de alumnos:

- https://azure.microsoft.com/es-es/free/students/

## Comenzando con máquinas virtuales (MV o VM)

Usaremos Open Azure Cloud Shell. Azure Cloud Shell es un shell interactivo gratuito que se puede utilizar para realizar las indicaciones de esta práctica. Las herramientas de Common Azure están preinstaladas y configuradas en Cloud Shell para que se puedan utilizar por los usuarios.

Para acceder a este terminal utilice el siguiente enlace: https://shell.azure.com/bash

### Creación del agrupamiento de recursos

Cree un grupo de recursos con el comando group create.

Un grupo de recursos Azure es un contenedor lógico en el que se despliegan y gestionan los recursos Azure. Se debe crear un grupo de recursos antes que una máquina virtual. En este ejemplo, se crea un grupo de recursos llamado myResourceGroup en la región este.

```
az group create --name myResourceGroup --location eastus
```

El grupo de recursos se especifica al crear o modificar una VM, el cual se puede ver a lo largo de este tutorial.


### Creación de una máquina virtual

Cree una máquina virtual con el comando az vm create.

Al crear una máquina virtual, hay varias opciones disponibles, como la imagen del sistema operativo, el tamaño del disco y las credenciales administrativas. El siguiente ejemplo crea una VM llamada myVM que ejecuta Ubuntu Server. Una cuenta de usuario llamada azureuser se crea en la VM. Las claves SSH se generan si no existen en la ubicación predeterminada de la clave ```(~/.ssh)``` y especificamos el tipo de disco duro estándar.

```
az vm create \
    --resource-group myResourceGroup \
    --name myVM \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --storage-sku Standard_LRS

```

La creación de la VM puede tardar unos minutos. Una vez que se ha creado la VM, el CLI Azure ( herramienta de la línea de comandos) produce información sobre la VM. Tome nota de la dirección publicIpAddress, esta dirección puede utilizarse para acceder a la máquina virtual.

Después de unos minutos: 

```
{
  "fqdns": "",
  "id": "/subscriptions/d5b9d4b7-6fc1-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/virtualMachines/myVM",
  "location": "eastus",
  "macAddress": "00-0D-3A-23-9A-49",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "XXXXXXXXXXXX",
  "resourceGroup": "myResourceGroup"
}
```

### Conéctese a la VM
Ahora puede conectarse a la VM con SSH en el Azure Cloud Shell o desde su ordenador local. Sustituya la dirección IP de ejemplo por la publicIpAddress indicada en el paso anterior.

```
ssh azureuser@XXXXXXXXXXX
```

Una vez que haya iniciado sesión en la VM, podrá instalar y configurar aplicaciones. Cuando haya terminado, cierre la sesión de SSH como de costumbre:

```
exit
```

### Mercado de imágenes VM

El mercado de Azure incluye muchas imágenes que se pueden utilizar para crear VMs. En los pasos anteriores, se creó una máquina virtual utilizando una imagen de Ubuntu. En este paso, el CLI de Azure se utiliza para buscar en el mercado una imagen CentOS, que luego se utiliza para desplegar una segunda máquina virtual.

Para ver una lista de las imágenes más utilizadas, utilice el comando az vm image list.

```
az vm image list --output table
```

### Máquinas virtuales funcionando

Lista de VM en ejecución:

```
az vm list
```

### Características de una máquina virtual

```
az vm show -g MyResourceGroup -n myVM -d
```

### Parar una máquina virtual

Parar una máquina virtual en funcionamiento

```
az vm stop -g MyResourceGroup -n myVM
```

### Iniciar una máquina virtual

Iniciar una máquina virtual detenida

```
az vm start -g MyResourceGroup -n myVM
```

### Reiniciar una máquina virtual

```
az vm restart -g MyResourceGroup -n myVM
```

### Eliminar una máquina virtual
```
az vm delete -g MyResourceGroup -n myVM --yes
```


### Abrir puertos de una máquina virtual

Por ejemplo: 

- Abrir el puerto de entrada de LDAP

```
az vm open-port -g MyResourceGroup -n myVM --port '389'
```

Ahora ve al DashBoard: (La gestión de máquinas virtuales puede hacerse también de forma gráfica)

- Inicio > Máquinas virtuales
- Haga clic en el nombre de su máquina virtual.
- Seleccione Redes.
- Agregar regla de puerto de entrada.


## Ejercicio práctico A (instalación de servicios de forma manual)

Crear un servidor web apache con php. Ha de ser posible acceder a la interfaz web desde la IP pública.



