## Práctica entregable 1: Diseño y despliegue de aplicaciones sobre plataformas cloud

#### Descripción

El objetivo de esta primera práctica es poner en uso los conocimientos adquiridos en relación con el uso de plataformas de cloud computing a nivel de IaaS y SaaS. Para ello, el alumno deberá realizar el diseño y posterior despliegue de una aplicación para gestión de archivos.

La aplicación que se desea desplegar precisa de los siguientes servicios:
- Autenticación basada en LDAP.
- Alojamiento, sincronización y compartición de archivos.
- Base de datos

#### Tareas

Para resolver el problema planteado, el alumno debe realizar las siguientes tareas:

1. Diseñar el sistema completo para implementar la aplicación. Deben establecerse qué paquetes de software se utilizarán para implementar cada uno de los bloques funcionales, así como detallar cuál es la interacción entre ellos. Debe responderse a la cuestión ¿Qué es necesario para garantizar la escalabilidad de la aplicación?
2. Despliegue sobre máquinas virtuales o contenedores del diseño anterior, asegurándose de la correcta interacción entre los distintos módulos.
3. Documentar el trabajo realizado mediante la redacción de una memoria. La estructura de este documento se ajustará a lo indicado más adelante.

Como sugerencia, se podría utilizar OpenLDAP para el soporte del sistema de autenticación, ownCloud para el almacenamiento, sincronización y compartición de archivos y MySQL para la base de datos. No obstante, esta decisión es del alumno y debe quedar convenientemente justificada.

#### Estructura de la memoria

Este documento explicativo del trabajo realizado se estructurará según las siguientes secciones:

1. Descripción del problema y explicar el problema a resolver.
2. Diseño y describir la estructura en módulos de la aplicación, componiéndola a partir de servicios, la selección de aplicaciones a utilizar para el despliegue de servicios y cómo interaccionan unos con otros. Explicar qué elementos hay que incluir y cómo insertarlos para garantizar la escalabilidad de la aplicación (en tamaño de almacenamiento y número de usuarios).
3. Despliegue y describir cómo se despliegan cada uno de los servicios que componen la aplicación, detallando las instrucciones de configuración y despliegue efectivo.
4. Breve manual de usuario.
5. Mejoras opcionales incluidas por el estudiante
6. Bibliografía.

#### Evaluación

El trabajo realizado para esta práctica se evaluará con hasta 2 puntos sobre el total de puntos de la parte práctica de la asignatura. En esta evaluación se incluirá tanto la documentación entregada (a través de prado.ugr.es) como la defensa presencial de la solución construida.

De forma opcional, podrá mejorarse la calificación en esta práctica con hasta 0,5 puntos adicionales mediante la inclusión de mejoras o utilización de herramientas que extiendan la funcionalidad de la plataforma. Algunos ejemplos serían: implementar la escalabilidad o utilizar herramientas para gestionar la infraestructura como código. Todas ellas deben documentarse adecuadamente en la memoria.

<!-- automatizar el despliegue con un script ---->

**Plazo de entrega: 5 de mayo de 2019 (hasta las 23:59)**
