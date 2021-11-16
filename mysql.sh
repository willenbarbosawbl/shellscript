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
    echo "Baixando o repositório."
    sudo wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.20-1_all.deb
    echo "Instalando o reposiótio."
    sudo dpkg -i mysql-apt-config_0.8.20-1_all.deb
    echo "Atualizando repositório do sistema."
    sudo apt update -y
    echo "Instalando o $programa"
    sudo apt install mysql-server -y
    echo "Iniciando a configuração de senha do $programa"
    echo "Coloque N não primeir pergunta"
    sudo mysql_secure_installation   
    echo "Status do $programa"
    sudo /etc/init.d/mysql status
    echo "Iniciando o $programa"
    sudo systemctl start mysql
    echo "Habilitando a iniciação automática do $programa"
    sudo systemctl enable mysql
    echo "$programa instalado com sucesso."     
fi