#!/bin/bash
#Author Randy Espino Lobaina

echo "####### Create networks #######"
docker network create --driver=bridge --subnet=172.28.1.0/24 front_end
docker network create --driver=bridge --subnet=172.28.2.0/24 back_end
docker network create --driver=bridge --subnet=192.168.99.0/24 servicio

echo "### Raise up proxy-inverso container ###"

docker create --name=proxy-inverso \
              --network=servicio \
              --ip=192.168.99.10 \
              -p 80:80 \
              -p 7878:7878 \
              proxy-inverso:alpine

docker network connect --ip=172.28.1.4 front_end proxy-inverso
docker start proxy-inverso

echo "### Raise up http-echo container ###"

docker create --name=http-echo \
              --network=front_end \
              --ip=172.28.1.2 \
              http-echo:alpine

docker start http-echo

echo "### Raise up wordpress container ###"
docker volume create wordpress

docker create --name=wordpress \
              --network=back_end \
	      --ip=172.28.2.2 \
              -e WORDPRESS_DB_HOST=172.28.2.3:3306 \
              -e WORDPRESS_DB_USER=exampleuser \
              -e WORDPRESS_DB_PASSWORD=examplepass \
              -e WORDPRESS_DB_NAME=exampledb \
              -v wordpress:/var/www/html \
              wordpress:latest

docker network connect --ip=172.28.1.3 front_end wordpress
docker start wordpress

echo "### Raise up Mysql-DB container ###"

docker volume create mysql 

docker create --name=mysql-db \
              --network=back_end \
              --ip=172.28.2.3 \
              -e MYSQL_DATABASE=exampledb \
              -e MYSQL_USER=exampleuser \
              -e MYSQL_PASSWORD=examplepass \
              -e MYSQL_RANDOM_ROOT_PASSWORD='1' \
              -v mysql:/var/lib/mysql \
              mysql:latest

docker start mysql-db
