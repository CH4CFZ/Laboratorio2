#!/bin/bash

#El directorio escogido es/home/isaacfz/archivo_prueba
directorio="/home/isaacfz/archivo_prueba"
#los mensajes log se iran aca
reportes="/home/isaacfz/reportes.txt"
inotifywait -m -q -e modify -e delete -e create "$directorio" |
       	while read; do
		echo "$(date) Ha ocurrido un cambio en el directorio" >> "$reportes"
	done
		


