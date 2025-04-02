#!/bin/bash


usuario=$(id -u)

if [[ "$usuario" -ne 0 ]]; then

	echo "Error, usted  no tiene permiso "
	exit 1
else
	echo "Gracias por ingresar"

fi

#Parte de los parametros

nombre=$1
grupo=$2
ruta=$3
#Validacion con el ! -e y envio del mensaje log a un archivo txt
mensaje="ERROR: la ruta no existe"
if [ ! -e "$ruta" ]; then
	echo "$mensaje" >> /home/isaacfz/scripts/mensajes_log.txt
	echo "$mensaje"
	exit 2
fi
aviso="El grupo ya existe"
if ! grep -q "^$grupo:" /etc/group; then 
	addgroup "$grupo" 
else
	echo "$aviso" >>/home/isaacfz/scripts/mensajes_log.txt
	echo "$aviso"
fi

if ! grep -q "^$nombre:" /etc/passwd; then
      	adduser "$nombre"
	usermod -a -G "$grupo" "$nombre"
else
	echo "El usuario ya existe"
	usermod -a -G "$grupo" "$nombre"
fi

chown "$nombre:$grupo" "$ruta"

chmod 740 "$ruta"

ls -l "$ruta"

