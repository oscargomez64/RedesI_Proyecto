# Imagen BIND9 de Ubuntu
FROM ubuntu/bind9:9.18-22.04_beta

# Copiamos los archivos de configuración de named y de zone
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local

RUN mkdir /etc/bind/zones
COPY zones/ /etc/bind/zones

# Abrimos el puerto 53
EXPOSE 53/udp
EXPOSE 53/tcp

# Instalamos el paquete que contiene la utilidad ping
RUN apt update && apt -y install iputils-ping

ENTRYPOINT ["docker-entrypoint.sh"]
