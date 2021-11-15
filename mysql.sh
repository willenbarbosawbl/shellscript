#!/bin/bash

programa="mysql-server"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

if [ -n "$pacote" ];
then
    echo "O programa ($programa) já está instalado!"
    echo "Verão do $programa"
    sudo mysql --version
    exit
else
    echo "Instalando o $programa"
    sudo apt install mysql-server -y
    echo "Status do $programa"
    sudo /etc/init.d/mysql status
    echo "Iniciando o $programa"
    sudo /etc/init.d/mysql start
    echo "Iniciando a configuração de senha do $programa"
    echo "Coloque N não primeir pergunta"
    sudo mysql_secure_installation
    
fi