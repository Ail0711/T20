#!/bin/bash

#Solicitar la direccion IP o el rango de IPs al usuario
read -p "Introduce la direccion IP o el rango de IPs a escanear: " ip_range

#Solicitar el rango de puertos al usuario
read -p "Introduce el rango de puertos a escanear (por ejemplo, 1-100): " port_range

#Escaneo de puertos con nmap
echo "Escaneando puertos con nmap..."
nmap -p $port_range $ip_range -oG - | grep "/open" > nmap_results.txt

#Leer los resultados de nmap y usar netcat para verificar los puertos abiertos
echo "Verificando puertos abietos con netcat..."
while read -r line; do
	ip=$ (echo $line | awk '{print $2}')
	ports=$ (echo $line | grep -oP '\d+/open' | cut -d '/' -f 1)
	for port in $ports; do
		nc -zv $ip $port 2>&1 | grep -q "open" && echo  "Puerto $port en $ip esta abierto"
	done
done < nmap_results.txt
