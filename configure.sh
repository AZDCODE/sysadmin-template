#!/bin/bash

set -e

# Comprovar permisos d'administrador
if [ "$EUID" -ne 0 ]; then
    echo "Error: executa aquest script amb sudo"
    exit 1
fi

# Anar a la carpeta on es troba el script
cd "$(dirname "$0")"

echo "Enabling swap..."
bash ./1_swap/swap.sh

echo "Configuring users..."
bash ./2_users/users.sh

echo "Enabling tmpfs..."
bash ./3_tmpfs/tmpfs.sh

echo "Configuracio completada correctament!"
