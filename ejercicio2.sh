#!/bin/bash

proceso=$1

if [ -z "$proceso" ]; then
	echo "Error: $0 ingrese un comando"
fi
#esta linea especial es la que permite que el comando se use
"$@" &

#Ahora voy a colocar el codigo para la parte del monitoreo

archivo="monitoreo.log"
#En esta varibale guardo el pid del proceso que se monitorea
pid=$! 
#Aqui realizo un ciclo que valide que el proceso siga vivo y utilizo un monitoreo cada dos segundos con el sleep 
while ps -p $pid > /dev/null; do
	cpu=$(ps -p $pid -o %cpu --no-headers)
        mem=$(ps -p $pid -o %mem --no-headers)
	#para esta parte use las banderas p y o, ya que asi controlo con el pid lo que se muestra en el archivo
        if [ -n "$cpu" ] && [ -n "$mem" ]; then
                echo "$(date) | CPU: $cpu | MEM: $mem" >> "$archivo"
        fi
	
	sleep 5
done

echo "$(date) | El proceso ha finalizado." >> "$archivo"

#Para la parte de la grafica hay que transformar los daros obtenidos en un formato compatible con gnuplot
awk -F'|' '{print NR, $2, $3}' monitoreo.log | sed 's/CPU://g; s/MEM://g' > datos.txt

# Aqui se definen los parametros del graficos
echo "
set title 'Uso del CPU y memoria'
set xlabel 'Tiempo (s)'
set ylabel 'Uso (%)'
set grid
set term png
set output 'grafico.png'
plot 'datos.txt' using 1:2 with lines title 'CPU', \
     'datos.txt' using 1:3 with lines title 'Memoria'
" > parametros.gnuplot
#ahi arriba se guardaron los parametros necesarios para que con el comando de abajo se ejecuten de manera adecuada

# Ejecutar Gnuplot
gnuplot parametros.gnuplot

