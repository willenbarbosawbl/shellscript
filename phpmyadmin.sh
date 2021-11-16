#!/bin/bash

programa="phpmyadmin"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

if [ -n "$pacote" ];
then
    echo "O programa ($programa) já está instalado!"    
    exit
else
    echo "Instalando o $programa."
    sudo apt install -y phpmyadmin
fi