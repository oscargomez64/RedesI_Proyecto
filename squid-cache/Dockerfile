# Imagen squid de Ubuntu
FROM ubuntu/squid

# Asignamos el usuario root para tener acceso a iptables
USER root

# Copiamos el archivo de de configuración
COPY squid.conf /etc/squid/squid.conf

# Copiamos los archivos de dominios y palabras a filtrar
COPY *.txt /etc/squid/

# Copiamos el script que ejecutará las ordenes de iptables
# y después manda a llamar el script de ejecución del contenedor
COPY squid_init.sh /usr/local/bin/squid_init.sh

# Asignamos el permiso de ejecución al script
RUN chmod +x /usr/local/bin/squid_init.sh

# Abrimos el puerto 3128
EXPOSE 3128

# Instalamos el paquete iptables y ping
RUN apt update && apt -y install iptables iputils-ping

ENTRYPOINT ["/usr/local/bin/squid_init.sh"]
CMD ["-f", "/etc/squid/squid.conf", "-NYC"]
