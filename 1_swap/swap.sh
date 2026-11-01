#!/bin/bash

set -e

SWAPFILE="/swapfile_prac3"

# Comprovar que el script s'executa com a root
if [ "$EUID" -ne 0 ]; then
    echo "Error: executa el script amb sudo"
    exit 1
fi

# Crear el fitxer de swap de 8 GiB
if [ ! -e "$SWAPFILE" ]; then
    echo "Creant el fitxer de swap..."
    dd if=/dev/zero of="$SWAPFILE" bs=1M count=8192 status=progress
fi

# Configurar els permisos
chmod 600 "$SWAPFILE"

# Preparar la swap nomes quan es crea per primera vegada
if ! blkid "$SWAPFILE" | grep -q 'TYPE="swap"'; then
    mkswap "$SWAPFILE"
fi

# Activar la swap si encara no esta activa
if ! swapon --show=NAME --noheadings | grep -Fxq "$SWAPFILE"; then
    swapon "$SWAPFILE"
fi

# Activar automaticament la swap en reiniciar
if ! grep -Fq "$SWAPFILE none swap" /etc/fstab; then
    echo "$SWAPFILE none swap sw 0 0" >> /etc/fstab
fi

echo "Swap activada correctament!"
swapon --show
free -h

