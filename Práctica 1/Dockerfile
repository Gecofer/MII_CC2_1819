# # Se utiliza la imagen de Ubuntu Trusty
FROM ubuntu:trusty

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen

# Eliminar si esta instalado MySQL
RUN rm -rf /var/lib/mysql/*

# Cambiar: bind address to 0.0.0.0
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

ADD crear_usuario.sh /crear_usuario.sh
ADD ejecutar.sh /ejecutar.sh

# Dar permisos de ejecucion, lectura y escritura
RUN chmod 775 /*.sh

# Poner VOLUME para permitir configurar la base de datos
# Se define dónde se va a ejecutar la base de datos
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

# Se abre el puerto 3306 para permitir la conexión
EXPOSE 3306

# Ejecuta permanentemente mysql
CMD ["/ejecutar.sh"]
