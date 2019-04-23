~~~
$ docker pull larrycai/openldap

Using default tag: latest
latest: Pulling from larrycai/openldap
bae382666908: Pull complete
29ede3c02ff2: Pull complete
da4e69f33106: Pull complete
8d43e5f5d27f: Pull complete
b0de1abb17d6: Pull complete
553e1c32b138: Pull complete
e003e67ebd1e: Pull complete
247af4e59d14: Pull complete
Digest: sha256:94f7120f3b2c07c9cda32c5db452d8d2d37f2d1d46783588970e6664fbd313be
Status: Downloaded newer image for larrycai/openldap:latest


$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
cvi087206:Sesión 5 gema$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ssbw_web            latest              2457bf070993        6 days ago          988MB
<none>              <none>              286ccff81808        6 days ago          988MB
mongo               4.0                 a3abd47e8d61        6 days ago          394MB
composetest_web     latest              b87d8febe492        7 days ago          83.8MB
copia               latest              76aff6dd92ff        7 days ago          180MB
img_test_mod        latest              41301f7433ac        7 days ago          175MB
test10              dockerfile          c1ec9f40064e        7 days ago          175MB
mongo-express       latest              376d1d9e0995        10 days ago         96MB
redis               alpine              3d2a373f46ae        10 days ago         50.8MB
python              3.4-alpine          5813992167c4        10 days ago         72.2MB
<none>              <none>              efeb47d334c6        13 days ago         969MB
<none>              <none>              1922f3e6538e        4 weeks ago         964MB
<none>              <none>              7aa8c1e11649        4 weeks ago         932MB
python              3                   338b34a7555c        5 weeks ago         927MB
ubuntu              latest              47b19964fb50        5 weeks ago         88.1MB
larrycai/openldap   latest              2ab06585ef11        18 months ago       223MB

$ docker run -d -p 389:389 --name ldap -t larrycai/openldap
a5cb7e013f7b07055d1cd38da6dfd98132deac420e7b21e5cde7dc98a04b13e3


$ docker ps

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
a5cb7e013f7b        larrycai/openldap   "/bin/sh -c 'slapd -…"   6 minutes ago       Up 6 minutes        0.0.0.0:389->389/tcp   ldap

$ docker exec -it a5cb7e013f7b /bin/bash
root@a5cb7e013f7b:/# ldapsearch -H ldap://localhost -LL -b ou=People,dc=openstack,dc=org -x
version: 1

No such object (32)
Matched DN: dc=openstack,dc=org
root@a5cb7e013f7b:/#
~~~


## Añadir un nuevo usuario

Crear un archivo user.ldif

~~~
# sudo apt-get update     

# sudo apt-get install nano

# nano user.ldif


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

# ldapadd -H ldap://localhost -x -D "cn=admin,dc=openstack,dc=org" -w password -c -f user.ldif
adding new entry "cn=fjbaldan,ou=Users,dc=openstack,dc=org"
~~~

## Cambiar el Password de un usuario en LDAP

~~~
# ldappasswd -s admin -W -D "cn=admin,dc=openstack,dc=org" -x "cn=fjbaldan,ou=Users,dc=openstack,dc=org"
~~~

## Modificando cuentas de usuario con LDAP: DELETE, MODIFY.

~~~
# nano fjbaldan_modify.ldif
dn: cn=fjbaldan,ou=Users,dc=openstack,dc=org
changetype: modify
replace: loginShell
loginShell: /bin/csh

# ldapmodify -x -D "cn=admin,dc=openstack,dc=org" -w password -H ldap://localhost -f fjbaldan_modify.ldif

ldapmodify -x -D "cn=admin,dc=openstack,dc=org" -w password -H ldap:// -f fjbaldan_modify.ldif
modifying entry "cn=fjbaldan,ou=Users,dc=openstack,dc=org"

root@a5cb7e013f7b:/# ldapsearch -H ldap://localhost -LL -b ou=Users,dc=openstack,dc=org -x

~~~




ldapmodify -x -D "cn=admin,dc=openstack,dc=org" -w password -H ldap://localhost -f fjbaldan_modify.ldif
modifying entry "cn=fjbaldan,ou=Users,dc=openstack,dc=org"

root@a5cb7e013f7b:/# cat user.ldif
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
root@a5cb7e013f7b:/# ldapmodify -x -D "cn=admin,dc=openstack,dc=org" -w password -H ldap:// -f fjbaldan_modify.ldif
modifying entry "cn=fjbaldan,ou=Users,dc=openstack,dc=org"

root@a5cb7e013f7b:/# cat user.ldif
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
root@a5cb7e013f7b:/# cat fjbaldan_modify.ldif
dn: cn=fjbaldan,ou=Users,dc=openstack,dc=org
changetype: modify
replace: loginShell
loginShell: /bin/csh
root@a5cb7e013f7b:/# ldapmodify -x -D "cn=admin,dc=openstack,dc=org" -w password -H ldap:// -f fjbaldan_modify.ldif
modifying entry "cn=fjbaldan,ou=Users,dc=openstack,dc=org"

root@a5cb7e013f7b:/# ldapsearch -H ldap://localhost -LL -b ou=Users,dc=openstack,dc=org -x
version: 1

dn: ou=Users,dc=openstack,dc=org
objectClass: organizationalUnit
ou: Users

dn: cn=Robert Smith,ou=Users,dc=openstack,dc=org
objectClass: inetOrgPerson
cn: Robert Smith
cn: Robert J Smith
cn: bob  smith
sn: smith
uid: rjsmith
carLicense: HISCAR 123
homePhone: 555-111-2222
mail: r.smith@example.com
mail: rsmith@example.com
mail: bob.smith@example.com
description: swell guy
ou: Human Resources

dn: cn=Larry Cai,ou=Users,dc=openstack,dc=org
objectClass: inetOrgPerson
cn: Larry Cai
sn: Cai
uid: larrycai
carLicense: HISCAR 123
homePhone: 555-111-2222
mail: larry.caiyu@gmail.com
description: hacker guy
ou: Development Department

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
gecos: fjbaldan
shadowMax: 0
shadowWarning: 0
loginShell: /bin/csh
