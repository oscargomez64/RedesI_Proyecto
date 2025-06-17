#!/bin/bash

# Bloquear el acceso al puerto 25 (SMTP)
iptables -A INPUT -p tcp --dport 25 -j DROP

# Bloquear las respuestas de ICMP tipo ping (echo-reply)
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Limitar el acceso simultaneo al servidor a un máximo de 20 equipos
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 16 -j DROP

# Bloquear trafico saliente a sitios con destino al puerto 443 (HTTPS)
# iptables -A OUTPUT -p tcp --dport 443 -j DROP

# Permitir tráfico al puerto 22 (SSH) desde una IP específica
iptables -A INPUT -p tcp --dport 22 -s 192.168.100.81 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

# SERVICIOS ADICIONALES A DENEGAR
# Denegar el acceso al puerto 631 (CUPS)
iptables -A INPUT -p tcp --dport 631 -j REJECT
iptables -A INPUT -p udp --dport 631 -j REJECT

# Denegar el acceso a SMB (puertos 139 y 445)
iptables -A INPUT -p tcp --dport 139 -j REJECT
iptables -A INPUT -p tcp --dport 445 -j REJECT

# Bloquear el acceso al puerto 23 (Telnet)
iptables -A INPUT -p tcp --dport 23 -j DROP

# Ejecutar script
# Squid OCI image entrypoint

# This entrypoint aims to forward the squid logs to stdout to assist users of
# common container related tooling (e.g., kubernetes, docker-compose, etc) to
# access the service logs.

# Moreover, it invokes the squid binary, leaving all the desired parameters to
# be provided by the "command" passed to the spawned container. If no command
# is provided by the user, the default behavior (as per the CMD statement in
# the Dockerfile) will be to use Ubuntu's default configuration [1] and run
# squid with the "-NYC" options to mimic the behavior of the Ubuntu provided
# systemd unit.

# [1] The default configuration is changed in the Dockerfile to allow local
# network connections. See the Dockerfile for further information.

# re-create snakeoil self-signed certificate removed in the build process
if [ ! -f /etc/ssl/private/ssl-cert-snakeoil.key ]; then
    /usr/sbin/make-ssl-cert generate-default-snakeoil --force-overwrite > /dev/null 2>&1
fi

tail -F /var/log/squid/access.log 2>/dev/null &
tail -F /var/log/squid/error.log 2>/dev/null &
tail -F /var/log/squid/store.log 2>/dev/null &
tail -F /var/log/squid/cache.log 2>/dev/null &
# create missing cache directories and exit
/usr/sbin/squid -Nz
/usr/sbin/squid "$@"
