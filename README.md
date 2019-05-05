# Cloud Computing: Servicios y Aplicaciones (Curso 2018-19)

**Repositorio Github: https://github.com/Gecofer/MII_CC2_1819**

# Práctica 1: Diseño y despliegue de aplicaciones sobre plataformas cloud

Gema Correa Fernández
gecorrea@correo.ugr.es

**Repositorio Práctica 1: https://github.com/Gecofer/MII_CC2_1819/tree/master/Práctica%201**

### Ficheros

- recursos.sh: crear el grupo de recursos y la red de las máquinas
- maquina1-owncloud.sh: crea la máquina virtual para ldap
- maquina2-mariadb.sh: crea máquina virtual para mariadb
- maquina3-ldap.sh: crea máquina virtual para ldap
- Dockerfile: para crear imagen de MariaDB (base de datos), necesita los ficheros crear_usuario.sh y ejecutar.sh
- gema.ldif	Fichero para añadir el usuario gema	al servidor LDAP
- antonio.ldif: fichero para añadir el usuario antonio al servidor LDAP
- practica1.pdf: guión de la práctica
- practica1-GemaCorrea.pdf: memoria de la práctica 1

### Como ejecutar

Puede encontrar los pasos explicados en el PDF.

1. Iniciar las máquinas virtuales en Azure.
2. Acceder a ellas mediante SSH.
  - ssh gemazure@40.87.121.16
  - ssh gemazure@40.76.48.185
  - ssh gemazure@40.76.48.185
3. En la máquina con owncloud: `sudo docker run -d -p 80:80 owncloud:latest`
  - Accedemos al navegador: http://40.87.121.16/
4. En la máquina con mariadb: `sudo docker run -d -p 3306:3306 -e MARIADB_PASS="mypass" gema/mariadb`
  - Accedemos a la página inicial de owncloud y ponemos:
    - user: admin
    - password: admin
    - user BD: admin
    - pass BD: mypass
    - database BD : prueba
    - host: 40.114.73.242:3306
5. En la máquina con ldap: `sudo docker container prune` y `sudo docker run -d -p 389:389 --name ldap -t osixia/openldap`
6. Añadir usuario a LDAP: `ldapadd -H ldap://40.76.48.185 -x -D "cn=admin,dc=example,dc=org" -w admin -c -f gema.ldif`
7. Cambiar contraseña: `ldappasswd -s admin -W -D "cn=admin,dc=example,dc=org" -x "cn=gema,ou=users,dc=example,dc=org"`
8. Instalar LDAP Registration en owncloud, que se encuentra en Market, dirigirse a Ajustes y Autentificación de usuario y configurar para el servidor LDAP.
  - servidor: ldap://40.76.48.185
  - puerto: 389
  - DN usuario: cn=admin,dc=example,dc=org
  - contraseña: admin
  - DN Base: dc=example,dc=org
9. Seleccionar que se entre con el nuevo usuario, a través de cn y userPassword. El filtro LDAP quedaría:
  ~~~
  (&(&(|(objectclass=account)(objectclass=posixAccount)(objectclass=shadowAccount)
  (objectclass=top))(|(memberof=cn=practica1,ou=groups,dc=example,dc=org)))
  (|(uid=%uid)(|(cn=%uid)(userPassword=%uid))))
  ~~~
10. Seleccionar las casillas sucesivas, salir de admin, y entrar con usuario: gema y contraseña: admin.
