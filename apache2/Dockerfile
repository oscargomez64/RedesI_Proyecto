# Imagen de Apache2 de Ubuntu
FROM ubuntu/apache2

# Asignamos el usuario root para tener acceso a iptables
USER root

# Copiamos todos los archivos .conf (vhosts) desde la carpeta local sites-available/
# a la carpeta de sitios disponibles de Apache dentro del contenedor
COPY sites-available/*.conf /etc/apache2/sites-available/

# Copiamos todos los sitios web (carpetas) desde la carpeta local sites/
# al directorio raíz de los documentos de Apache dentro del contenedor
COPY sites/ /var/www/

# Copiamos el script que ejecutará las ordenes de iptables
# y después manda a llamar el script de ejecución del contenedor
COPY apache_init.sh /usr/local/bin/apache_init.sh

# Asignamos el permiso de ejecución al script
RUN chmod +x /usr/local/bin/apache_init.sh

# Abrimos el puerto HTTP
EXPOSE 80

# Instalamos el paquete iptables y ping
RUN apt update && apt -y install iptables iputils-ping

# Habilitamos los sitios web para que estén en sites-available/
# y reiniciamos el servicio
RUN a2ensite sitio1.prored.test.conf
RUN a2ensite sitio2.prored.test.conf
RUN a2ensite sitio3.prored.test.conf
RUN a2dissite 000-default.conf

# Ejecuta el script
CMD ["/usr/local/bin/apache_init.sh"]
