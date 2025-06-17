#!/bin/bash

# Bloquear el acceso al puerto 80 (HTTP)
iptables -A INPUT -p tcp --dport 80 -j DROP

# Bloquear las respuestas de ICMP tipo ping (echo-reply)
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Limitar el acceso simultaneo al servidor a un máximo de 20 equipos
iptables -A INPUT -p tcp --dport 53 -m connlimit --connlimit-above 20 --connlimit-mask 16 -j DROP

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

# Script de docker-entrypoint.sh
set -e

# allow arguments to be passed to named
if [[ "${1:0:1}" == '-' ]]; then
    EXTRA_ARGS="${*}"
    set --
elif [[ "${1}" == "named" || "${1}" == "$(command -v named)" ]]; then
    EXTRA_ARGS="${*:2}"
    set --
fi

# The user which will start the named process.  If not specified,
# defaults to 'bind'.
BIND9_USER="${BIND9_USER:-bind}"

# default behaviour is to launch named
if [[ -z "${1}" ]]; then
    echo "Starting named..."
    echo "exec $(which named) -u \"${BIND9_USER}\" -g \"${EXTRA_ARGS}\""
    exec $(command -v named) -u "${BIND9_USER}" -g ${EXTRA_ARGS}
else
    exec "${@}"
fi
