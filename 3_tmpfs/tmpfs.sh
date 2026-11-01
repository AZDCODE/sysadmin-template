#!/bin/bash

set -e

TMPFS_DIR="/mnt/prac3_tmpfs"
TMPFS_SIZE="512M"

# Comprovar permisos d'administrador
if [ "$EUID" -ne 0 ]; then
    echo "Error: executa el script amb sudo"
    exit 1
fi

# Crear la carpeta on muntarem la tmpfs
mkdir -p "$TMPFS_DIR"

# Comprovar si ja esta muntada
if mountpoint -q "$TMPFS_DIR"; then
    echo "La tmpfs ja esta muntada."
else
    # Muntar tmpfs de 512 MiB
    mount -t tmpfs -o size="$TMPFS_SIZE",mode=1777 \
        tmpfs "$TMPFS_DIR"

    echo "Tmpfs muntada correctament!"
fi

# Mostrar informacio
df -h "$TMPFS_DIR"

