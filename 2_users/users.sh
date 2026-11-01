#!/bin/bash

set -e

# Comprovar que el script s'executa com a administrador
if [ "$EUID" -ne 0 ]; then
    echo "Error: executa el script amb sudo"
    exit 1
fi

# Crear el grup profes si no existeix
if ! getent group profes > /dev/null; then
    groupadd profes
fi

# Crear els tres usuaris i afegir-los al grup
for user in ferran pablo oriol; do

    if ! id "$user" &> /dev/null; then
        useradd -m -s /bin/bash "$user"
    fi

    usermod -aG profes "$user"

done

# Crear la carpeta compartida
mkdir -p /tmp/prac3

# Configurar el propietari i el grup
chown root:profes /tmp/prac3
chmod 2770 /tmp/prac3

# Crear el fitxer compartit
echo "Aquest fitxer es compartit pels professors" > /tmp/prac3/compartit.txt

chown ferran:profes /tmp/prac3/compartit.txt
chmod 770 /tmp/prac3/compartit.txt

# Crear els fitxers privats
for user in ferran pablo oriol; do

    echo "Aquest es el fitxer privat de $user" > "/tmp/prac3/$user.txt"

    chown "$user":profes "/tmp/prac3/$user.txt"
    chmod 700 "/tmp/prac3/$user.txt"

done

echo "Configuracio completada correctament!"
ls -la /tmp/prac3

