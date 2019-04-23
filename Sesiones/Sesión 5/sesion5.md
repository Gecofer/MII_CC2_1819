## Ejercicio: Crear un servicio de directorio LDAP en contendor dentro de una MV

Para este ejercicio es necesario crear o reutilizar una de las MVs que tengas disponibles para añadir:

- Servicio de contenedores docker. Instala Docker.
- Servicio de Directorio LDAP. Para ello instala dentro de docker:

```
sudo docker pull larrycai/openldap
sudo docker run -d -p 389:389 --name ldap -t larrycai/openldap
```

- Abre el puerto en las políticas de seguridad de Azure (web), para poder acceder desde fuera al contenedor.
- Usa el comando para verificar que tu instalación es correcta.

```
ldapsearch -H ldap://< IP De tu MV > -LL -b ou=People,dc=openstack,dc=org -x
```

exec -

- Añade tu usuario a LDAP y incluye un atributo que sea Teléfono.


----


docker images

$ docker exec -it a5cb7e013f7b /bin/bash

root@a5cb7e013f7b:/# ldapsearch -H ldap://localhost -LL -b ou=People,dc=openstack,dc=org -x


---
Las contraseñas que se suelen usar en LDAP

admin
admin

admin
password


### Verificando el estado del directorio LDAP

Primero comprueba que estás dentro del servidor LDAP o bien dentro de una de tus MVs (con las herramientas de LDAP instaladas), si el usuario existe:
ldapsearch -H ldap://192.168.0.77 -LL -b ou=Users,dc=openstack,dc=org -x

Esto, imprime por pantalla el listado Usuarios del servicio de directorio, es decir, en texto plano:

podemos poner todos los datos que queramos, los usuarios no tienen que tener las mismas estrgucturas. Es muy fácil, cuando cambiemos la arquitectura.  Este tipo de fichero, cuesta de mantener, pero sino hay que modificar algo

https://docs.centos.org/5/html/CDS/ag/8.0/Finding_Directory_Entries-Using_ldapsearch.html: no funciona


Con generar un usuaro root y un usuario base para la práctica, vale.


### Añadir un nuevo usuario

Crear un archivo, es decir, user.ldif y copiar este esqueleto, modificar e incluir sus datos (es decir, cn=fjbaldan a cn=< usuario >, es decir, uid=fjbaldan a uid=<uid>, gecos etc.). Estos campos tienen que ser unicos.

~~~
dn: cn=fjbaldan,ou=Users,dc=openstack,dc=org
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: fjbaldan
uid: fjbaldan
uidNumber: 16859
gidNumber: 100
homeDirectory: /home/fjbaldan
loginShell: /bin/bash
gecos: fjbaldan
userPassword: {crypt}x
shadowLastChange: 0
shadowMax: 0
shadowWarning: 0
~~~

Se genera un fichero con esa estructura, es decir, se cogio el que habia y se modifica el id y el nombre con los que he puesto.
