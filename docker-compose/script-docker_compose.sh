#!/bin/bash
#Author: Randy Espino Lobaina

cadena=""

read -p " Desea levantar la solucion con Docker Compose con los datos persistentes ('S' o 'N')?: " cadena

if [[ "$cadena" == "S" ]]; then
	docker stop http-echo wordpress db proxy-inv
	docker rm http-echo wordpress db proxy-inv
	docker-compose -f /home/randy/Documents/docker-compose/docker-compose.yml up
else
	echo "Levantando solucion Docker Compose desde cero"
        docker stop http-echo wordpress db proxy-inv
        docker rm http-echo wordpress db proxy-inv
        rm -rf /var/lib/docker/volumes/mysql/_data/*
        rm -rf /var/lib/docker/volumes/wordpress/_data/*
        docker-compose -f /home/randy/Documents/docker-compose/docker-compose.yml up
fi
