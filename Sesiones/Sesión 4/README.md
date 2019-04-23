Asignatura Cloud Computing del Máster en Ingeniería Informática. 

Departamento de Ciencias de la Computación e Inteligencia Artificial.

Universidad de Granada.

<HR>

Profesor: **Francisco Javier Baldán Lozano**

Email: **fjbaldan@decsai.ugr.es**

Tutorías: **Lunes, de 11:00 a 12:00, despacho D31 (4ª planta) Escuela Técnica Superior de Ingenierías Informática y de Telecomunicación (ETSIIT). Se recomienda concretar las citas por correo.**

Material de prácticas de la asignatura: **https://github.com/fjbaldan/PracticasCC**

Francisco Javier Baldán Lozano (fjbaldan@decsai.ugr.es), Enero 2019
![DICITSlogo](http://sci2s.ugr.es/dicits/images/dicits.png)

Material realizado a partir del trabajo de años anteriores de Manuel Parra & José Manuel Benitez: https://github.com/DiCITS/MasterCienciaDatos2019 & https://github.com/manuparra/PracticasCC

<HR>


# Sesión 4: Creación de tus propios contenedores

Tabla de contenido:

  * [Requisitos iniciales](#requisitos-iniciales)
  * [Credenciales y acceso inicial](#credenciales-y-acceso-inicial)
  * [Acceso vía SSH](#acceso-vía-ssh)
  * [Creación de un contenedor](#creación-de-un-contenedor)
    + [Creación de una imagen](#entrenando-con-ldap)
    + [Obtención-del-contenedor](#obtención-del-contenedor)
  * [Ejercicio: Crear un contenedor con mysql configurado para acceso exterior](#ejercicio--crear-un-servicio-de-directorio-ldap-en-contendor-dentro-de-una-mv)


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


## Creación de un contenedor
Comenzamos creando un directorio de pruebas en el que vamos a desarrollar la creación de los contenedores de esta sesión. Creamos el fichero Dockerfile que contendrá la configuración básica de la imagen:
```
mkdir containertest
cd containertest
vi Dockerfile
```

FROM indica la imagen del S.O. de la que partimos.

RUN indica los comandos a ejecutar.

CMD indica el comando por defecto a utilizar.

```
FROM ubuntu:latest

RUN apt-get -y update; \
    apt-get -y upgrade; \
    apt-get -y install apt-utils \
    vim;

CMD ["bash"]
```
Tras crear el fichero de configuración pasamos a construir la imagen:
```
sudo docker build  -t "test10:dockerfile" .
```
Una vez creada, debemos ser capaces de verla en el listado de imágenes de docker:

```
sudo docker images
```

Se puede observar el identificador, su tamaño y hace cuanto tiempo se creó:
```
azureuser@MYVM:~/containertest$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test10              dockerfile          45e792a87d93        12 minutes ago      198MB
```

Tras verificar que se ha creado la imagen, procedemos a crear su correspondiente contenedor:
```
azureuser@MYVM:~/containertest$ sudo docker run -dti --name testcontainer 45e792a87d93
a49078b1bef8f7ea6c5b22f94214a68f9ad44b3a046d63e0b4e5866b10cd81e2
azureuser@MYVM:~/containertest$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
a49078b1bef8        45e792a87d93        "bash"              12 minutes ago      Up 12 minutes                           testcontainer

```

A continuación vamos a comprobar que el contenedor cuenta con el software especificado. Para ello accedemos a la imagen y ejecutamos los diferentes programas:
```
azureuser@MYVM:~/containertest$ sudo docker exec -i -t testcontainer /bin/bash
root@a49078b1bef8:/# vim
```

Puede verse que el editor vim está instalado.

Es posible que se necesite crear un contenedor con una configuración determinada adaptada a una series de servicios o necesidades específicas que no están cubiertas en la instalación por defecto. Por ello es necesario saber cómo exportar una imagen de un contenedor modificada para poder distribuirla donde sea necesario. Para ello, tras modificar lo necesario en el contenedor la imagen del mismo puede exportarse de la siguiente forma:
```
sudo docker commit CONTAINER_ID img_test_mod
```
De esta forma se ha creado una imagen del contenedor modificado.

Esta imagen se exportaría en un archivo .tar:
```
sudo docker image save img_test_mod > out.tar
```
Para importar dicha imagen en cualquier máquina se haría de la siguiente forma:
```
sudo docker image import out.tar [Repository:Tag]
```

## Opciones adicionales de interés
Nuestros contenedores pueden tener diferentes necesidades a la hora de su creación, por este motivo vamos a ver las herramientas disponibles en la creación de contenedores (Dockerfile):

-MAINTAINER: Permite al autor especificar sus datos: nombre, dirección de correo electrónico, etc.

-ENV: Especificar variables de entorno.

-ADD: Permite añadir ficheros al sistema de ficheros del contenedor. (Pueden ser URL o archivos comprimidos, los cuales serán descomprimidos cuando se añadan al contenedor)

-COPY: Añade ficheros al sistema de ficheros del contenedor pero sin las opciones adicionales con las que cuenta ADD. Se recomienda el uso de COPY para cualquier caso que no requiera específicamente de ADD.

-EXPOSE: Especifica los puertos que va a escuchar el contenedor. (Es necesario especificar cuando se lanza el contenedor dicho puertos para que sean accesibles desde el host.)

-VOLUME: Permite al contenedor acceder a una ubicación del host. Estos volúmenes serán siempre accesibles en /var/lib/docker/volumes/.

-WORKDIR: Directorio donde se ejecutan todas las acciones.

-USER: Especifica el usuario que realizará las acciones. Por defecto es el root.

-ARG: Nos permite añadir parámetros al Dockerfile.

## Ejercicio: Crear un contenedor con mysql configurado para acceso exterior

## Docker Compose: Crear un servicio web y base de datos modificable sin corte de servicio.
