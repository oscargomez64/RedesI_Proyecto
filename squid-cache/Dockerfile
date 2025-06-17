# Imagen squid de Ubuntu
FROM ubuntu/squid

# Copiamos el archivo de de configuración
COPY squid.conf /etc/squid/squid.conf

# Copiamos los archivos de dominios y palabras a filtrar
COPY *.txt /etc/squid/

# Abrimos el puerto 3128
EXPOSE 3128

# Instalamos el paquete que contiene la utilidad ping
RUN apt update && apt -y install iputils-ping

ENTRYPOINT ["entrypoint.sh"]
CMD ["-f", "/etc/squid/squid.conf", "-NYC"]
