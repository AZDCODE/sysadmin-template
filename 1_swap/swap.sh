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

# Preparar el fitxer com a swap, si encara no esta activat
if ! swapon --show=NAME --noheadings | grep -Fxq "$SWAPFILE"; then
    mkswap "$SWAPFILE"
    swapon "$SWAPFILE"
fi

echo "Swap activada correctament!"
swapon --show
free -h

