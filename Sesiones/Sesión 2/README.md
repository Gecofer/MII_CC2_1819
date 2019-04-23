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


# Sesión 2: Despliegue automatizado de software y servicios 

Tabla de contenido:

  * [Requisitos iniciales](#requisitos-iniciales)
  * [Acceso vía SSH](#acceso-vía-ssh)
  * [Despliegue automático de servicios y software](#despliegue-automático-de-servicios-y-software)
  * [Breve introducción a ANSIBLE](#breve-introducción-a-ansible)
    + [Elementos en ANSIBLE](#elementos-en-ansible)
    + [Instalación de ANSIBLE](#instalación-de-ansible)
    + [Definición del fichero de inventario](#definición-del-fichero-de-inventario)
    + [PlayBooks básicos](#playbooks-básicos)
  * [Despliegue de software y servicios sobre MV](#despliegue-de-software-y-servicios-sobre-mv)
    + [Creamos el fichero de inventario](#creamos-el-fichero-de-inventario)
    + [Instalamos un servicio web](#instalamos-un-servicio-web)
  * [Despliegue de servicios relacionados con la práctica del curso](#despliegue-de-servicios-relacionados-con-la-práctica-del-curso)


## Requisitos iniciales

- Tener cuenta de correo de alumno de la universidad.
- Conocimientos básicos del SHELL.
- Conceptos básicos de Cloud y Máquinas Virtuales.

## Acceso vía SSH

Para usar SSH, utilízalo desde la consola de Linux o bien desde Windows usando la aplicación ``putty``.

Si usas Windows descarga ``putty`` desde: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html e indica los siguientes datos en la pantalla de configuración:

- Hostname or IP: ``XXXXXXXX``
- Port: ``22``
- Connection Type: ``SSH``

Y luego ``Open`` para conectar, donde te pedirá después las credenciales de acceso.

Si usas SSH desde una consola:

``ssh usuario@XXXXXXXX``


## Despliegue automático de servicios y software

El despliegue de herramientas y servicios, se puede realizar de múltiples formas. Desde las herramientas tradicionales 
como utilizar un shell-script hasta las más modernas y completas como utilizar ``ansible``, ``chef``, ``puppet`` o ``salt``.

¿Cuál es la ventaja de usar una de las herramientas de automatización como ``ansible`` ?

No es necesario 'a priori' conocer la distribución de Linux o el soporte final del Sistema Operativo sobre el cual vamos 
a desplegar el software o los servicios. Con ``ansible`` podemos indicarle que instale unos paquetes, pero no le decimos que use 
``apt`` para el caso concreto, por lo que es la propia herramienta ``ansible`` la que 'conoce' como tiene que instalar el software para 
el sistema  final.

Con este tipo de herramientas de automatización conseguiremos:

- Automatizar el aprovisionamiento de máquinas.
- Centralizar la gestión e instalación de servicios y software.
- Gestionar la configuración de los servicios de esas máquinas.
- Realizar despliegues y orquestar los servicios.
- Dotar a nuestros despliegues de solidez.

En cambio si usamos los métodos tradicionales de usar un ``shell-script``, necesitaremos adaptarlo a nuestra distribución, copiarlo en todos 
los nodos, etc. 

## Breve introducción a ANSIBLE

Ansible es una herramienta de gestión y aprovisionamiento de configuraciones, similar a Chef, Puppet o Salt.

Solo SSH:  utiliza SSH para conectarse a servidores y ejecutar las Tareas configuradas en los llamados ``playbooks``.

Una cosa agradable acerca de Ansible es que es muy fácil convertir scripts bash (todavía una manera popular de realizar la gestión de configuración) en Ansible Tasks. Puesto que se basa principalmente en SSH, no es difícil ver por qué este podría ser el caso - Ansible termina ejecutando los mismos comandos.

 Ansible automatiza el proceso antes de ejecutar Tareas utilizando contextos. Con este contexto, Ansible es capaz de manejar la mayoría de los casos de límite - del tipo que solemos tratar con scripts más largos y cada vez más complejos.

Las Tareas en ANSIBLE son identificables. Sin una gran cantidad de codificación extra, los scripts shell-bash no suelen funcionar de forma segura una y otra vez. Ansible utiliza "Hechos", que es información del sistema y del entorno que recopila ("contexto") antes de ejecutar Tareas.

Ansible usa estos hechos para comprobar el estado y ver si necesita cambiar algo para obtener el resultado deseado. Esto hace que sea seguro ejecutar Ansible Tasks contra un servidor una y otra vez.


### Elementos en ANSIBLE

- Controller Machine: la máquina donde Ansible está instalado, responsable de ejecutar el aprovisionamiento en los servidores que está gestionando.
- Inventario: un archivo INI que contiene información sobre los servidores que está gestionando.
- Playbook: el punto de entrada para aprovisionamientos Ansible, donde la automatización se define a través de tareas con formato YAML.
- Tarea: bloque que define un procedimiento único a ejecutar, por ejemplo: instalar un paquete.
- Módulo: un módulo suele resumir una tarea del sistema, como tratar con paquetes o crear y cambiar archivos. Ansible tiene una multitud de módulos incorporados, pero también puede crear otros personalizados.
- Rol: una forma predefinida de organizar playbooks y otros archivos para facilitar el compartir y reutilizar partes de un aprovisionamiento.
- Hechos: variables globales que contienen información sobre el sistema, como interfaces de red o sistema operativo.
- Manipuladores: se utilizan para desencadenar cambios en el estado de servicio, como reiniciar o detener un servicio.




### Instalación de ANSIBLE

En el nodo principal de Azure ya está instalado ANSIBLE, con lo que no tendrás que instalarlo.

Si lo quieres instalar en las instancias de Azure que hayas creado para orquestar la instalación desde una de ella, usa:

```
sudo apt install ansible
```


### Definición del fichero de inventario

Ansible trabaja contra múltiples sistemas en su infraestructura al mismo tiempo. Esto lo hace seleccionando porciones de sistemas listados en el inventario de Ansible, que por defecto se guarda en la ubicación ``/etc/ansible/hosts``. Se puede especificar un archivo de inventario diferente utilizando la opción ``-i <path>`` en la línea de comandos al utilizar los  PlayBooks.

Este inventario no sólo es configurable, sino que también puede utilizar múltiples archivos de inventario al mismo tiempo y extraer el inventario de fuentes dinámicas o de nube o diferentes formatos (YAML, ini, etc).

Para nuestras prácticas definiremos un fichero de hosts propio, donde se hará el inventario de máquinas que se usarán para todo el curso.



### PlayBooks básicos

Los Playbooks pueden ejecutar múltiples Tareas y proporcionar algunas funciones más avanzadas que nos perderíamos usando comandos ad-hoc. 

Los PlayBooks son ficheros de texto en formato YAML.


Un ejemplo de fichero PlayBook:

```
---
- hosts: local
  become: true
  tasks:
   - name: Install Nginx
     apt: pkg=nginx state=installed update_cache=true
```

Lo desgranamos:

- El PlayBook se ejecutará en el equipo llamado ``local``
- Contiene una serie de tareas identificadas por ```tasks```:
 - Una de las tareas es instalar NGINX, debe estar instalado y además que se actualice la cache del repositorio de paquetes.
 - Además la tarea es que use ``apt`` para instalar.

¿Cómo lo ejecutamos?:

```
ansible-playbook -s nginx.yml 
```

Otro ejemplo para instalar APACHE y PHP:

```
---
- hosts: local
  become: true
  tasks:
   - name: Install Apache
     apt: pkg=apache2 state=installed 
   - name: Install PHP
     apt: pkg=php state=installed 
```


## Despliegue de software y servicios sobre MV

Creamos una nueva instancia dentro de Azure. Esta instancia la usaremos para probar el despliegue de software dentro de la MV.

```
az vm create \
    --resource-group myResourceGroup \
    --name myVMtest \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --storage-sku Standard_LRS
```

Nos conectamos a ella:

```
ssh azureuser@192.168.0.XXX
```

Si todo es correcto, salimos de la MV creada y volvemos al nodo de Azure (si estás dentro de la instancia, sal con ``exit``).

### Creamos el fichero de inventario

Dentro de tu HOME de Azure, debes crear un fichero de inventario de hosts. Este fichero contiene la lista de IP/Hosts que 
se usarán para desplegar e instalar software.

Para ello, creamos un fichero que se llame por ejemplo ``hosts`` (usa pico, joe, vi/vim, etc...):

```
vi hosts
```

y añadimos el siguiente contenido:

```
[MVs]
< IP de tu máquina > ansible_connection=ssh ansible_user=azureuser
```

Sustituye la IP ``< IP de tu máquina >``, por la correspondiente de tu instancia.

y guardamos el fichero.

Explicamos el contenido del fichero:

- Grupo de Hosts que se llama ```[MVs]```
- Línea de hosts:
 - IP de la instancia que queramos desplegar:
 - ansible_ssh_private_key_file=tuficherokey.pem Indica el nombre del fichero de tu llave de ssh que se usará para conectar a la instancia.
 - ansible_user=azureuser Indica el usuario que usaremos para conectar


En este fichero iremos guardando todo el inventario de MVs que tengamos que desplegar con software o servicios para la práctica. En él tendrás que ir añadiendo todas tus instancias.

### Instalamos un servicio web

Creamos un fichero que se llame por ejemplo: ```nginx.yml``` y añadimos el siguiente contenido (usa pico, joe, vi/vim, etc... instala el que quieras):

```
---
- hosts: MVs
  become: true
  tasks:
   - name: Install Nginx
     package: pkg=nginx state=installed 


```

Y ahora ejecutamos:

```
ansible-playbook -s nginx.yml -i hosts
```

Ya está instalado NGINX, pero no está iniciado en la MV, por lo que tenemos que añadir al fichero ``nginx.yml`` lo siguiente, un gestor:

```
---
- hosts: MVs
  become: true
  tasks:
   - name: Install Nginx
     package: pkg=nginx state=installed
     notify:
      - Start Nginx

  handlers:
   - name: Start Nginx
     service: name=nginx state=restarted enabled=yes
```


Comprobamos que podemos ver la web que se ha desplegado:

```
lynx < IP de tu máquina >
```

*Recuerda abrir el puerto 80 en tus políticas de seguridad de grupo*


## Despliegue de servicios relacionados con la práctica del curso

Para la primera práctica necesitaremos una serie de servicios que se habilitarán desde las instancias que se crearán de forma programática.

Estas instancias deben contener un software específico para cada servicio que se despliega en ellas y que servirá para 

Necesitaremos instalar en instancias separadas:

- Nodo de cabecera (1 nodo):
  - NGINX o HAproxy
- Nodos de servicio (1-2 nodos):
  - Servicio de contenedores (docker)
  - Nodo de Base de Datos (1 nodo)
  - Nodo para autenticación (1 nodo)
