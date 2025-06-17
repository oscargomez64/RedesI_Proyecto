#!/bin/sh

# Bloquear el acceso al puerto 21 (FTP)
iptables -A INPUT -p tcp --dport 21 -j DROP

# Bloquear las respuestas de ICMP tipo ping (echo-reply)
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Limitar el acceso simultaneo al servidor a un máximo de 20 equipos
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 16 -j DROP

# Bloquear trafico saliente a sitios con destino al puerto 443 (HTTPS)
iptables -A OUTPUT -p tcp --dport 443 -j DROP

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

# Script de apache2-foreground
set -e

export APACHE_RUN_DIR=/var/run/apache2
export APACHE_ARGUMENTS="-DFOREGROUND $@"

# Apache gets grumpy about PID files pre-existing
rm -f ${APACHE_RUN_DIR}/apache2.pid

exec /usr/sbin/apachectl start
