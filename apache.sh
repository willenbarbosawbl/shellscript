#!/bin/bash

programa="apache2"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

if [-n "$pacote"]
then
    echo "O programa ($programa) já está instalado!"
    exit
else
    echo "O programa ($programa) ainda não está instalado!"
    echo "Instalando o $programa!"
    sudo apt install $programa -y
    echo "Versão do $programa"    
    $programa -version
    echo "Estado do $programa"
    sudo /etc/init.d/$programa status    
    echo "Habilitando o mod_rewrite (URL Amigável)"
    sudo a2enmod rewrite
    echo "Reiniciando o $programa"    
    sudo /etc/init.d/$programa restart
    echo "$programa instalado e url amaigável habilitada!"
fi