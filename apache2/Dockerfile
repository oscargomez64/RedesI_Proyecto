# Imagen de Apache2 de Ubuntu
FROM ubuntu/apache2

# Copiamos todos los archivos .conf (vhosts) desde la carpeta local sites-available/
# a la carpeta de sitios disponibles de Apache dentro del contenedor
COPY sites-available/*.conf /etc/apache2/sites-available/

# Copiamos todos los sitios web (carpetas) desde la carpeta local sites/
# al directorio raíz de los documentos de Apache dentro del contenedor
COPY sites/ /var/www/

EXPOSE 80

# Instalamos el paquete que contiene la utilidad ping
RUN apt update && apt -y install iputils-ping

# Habilitamos los sitios web para que estén en sites-available/
# y reiniciamos el servicio
RUN a2ensite sitio1.prored.test.conf
RUN a2ensite sitio2.prored.test.conf
RUN a2ensite sitio3.prored.test.conf
RUN a2dissite 000-default.conf
CMD ["apachectl", "-D", "FOREGROUND"]
