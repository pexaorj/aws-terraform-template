#!/bin/bash

#Sleep 120 - a instancia pode levantar sem ter um ip real, nao deixando com que ela execute o user-data - workaround


#Update system - instala docker
apt-get update -y 
apt-get install docker docker-compose -y 
apt-get install unzip -y 

#Inicia o docker
/etc/init.d/docker start

update-rc.d docker enable 2

#Faz o pull das imagens que serao utilizadas
