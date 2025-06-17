# Imagen BIND9 de Ubuntu
FROM ubuntu/bind9:9.18-22.04_beta

# Asignamos el usuario root para tener acceso a iptables
USER root

# Copiamos los archivos de configuración de named y de zone
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local

RUN mkdir /etc/bind/zones
COPY zones/ /etc/bind/zones

# Copiamos el script que ejecutará las ordenes de iptables
# y después manda a llamar el script de ejecución del contenedor
COPY bind9_init.sh /usr/local/bin/bind9_init.sh

# Asignamos el permiso de ejecución al script
RUN chmod +x /usr/local/bin/bind9_init.sh

# Abrimos el puerto 53
EXPOSE 53/udp
EXPOSE 53/tcp

# Instalamos el paquete iptables y ping
RUN apt update && apt -y install iptables iputils-ping

# Ejecuta el script
ENTRYPOINT ["/usr/local/bin/bind9_init.sh"]
