#!/bin/bash

programa="apache2"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

echo "Configurando diretório padrão do $programa."
echo "Qual é a pasta de arquivos padrão? 1 - www(Padrão) 2 - user(Usuário) 3 - externo(personalizada)"
read pasta
if [ "$pasta" = "1" ];
then
    dir_server=/var/www/html
    euser="n"
    dire="n"
elif [ "$pasta" = "2" ];
then
    dir_server=/$home/$user/servidor    
    euser="s"
    dire="n"
elif [ "$pasta" = "3" ];
then
    echo "Informe o caminho da pasta do servidor (exp.: /media/BKP/servidor) "
    read caminho_server
    dir_server=$caminho_server
    euser="n"
    dire="s"
else
    echo "Você não informou pasta de arquivos padrão"
    exit
fi

echo "Alterando configuração do $programa."
sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
echo "Alterando pasta de arquivos do $programa."
linha="<Directory $dir_server/public_html/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
       </Directory>"
echo "$linha" >> /etc/apache2/apache2.conf
echo "Excluindo o arquivo 000-default.conf do $programa"
sudo rm -rf /etc/apache2/sites-available/000-default.conf
echo "Contruindo novo 000-default.conf personalizado"
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/000-default.conf
echo "#ServerName www.exemplo.com" >> /etc/apache2/sites-available/000-default.conf
echo "#ServerAlias exemplo.com" >> /etc/apache2/sites-available/000-default.conf
echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/000-default.conf
echo "DocumentRoot $dir_server/public_html" >> /etc/apache2/sites-available/000-default.conf
echo "ErrorLog $dir_server/logs/error.log" >> /etc/apache2/sites-available/000-default.conf
echo "Customlog $dir_server/logs/access.log combined" >> /etc/apache2/sites-available/000-default.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
echo "Recaregando configurações do $programa"
sudo /etc/init.d/$programa reload
echo "Criando pasta de arquivos do servidor"
#Verifica se a pasta de arquivos do servidor é de usuário
if [ "$euser" = "s" ];
then
    #Verifica se o usuário existe
    verificauser=$(grep -w ^$user /etc/passwd | cut -d: -f 1)
    if [ -z $verificauser ];
    then
        echo "O usuário ($user) não existe!"
        echo "Pasta public_html não criada."
        vu="n"
    else
        vu="s"
    fi
fi

if [ $vu="s" ];
then
    echo "Verficando se pasta public_html já existe."
    echo $dir_server
    if [ ! -d "$dir_server" ];
    then
        echo "Pasta não existe."
        echo "Criando pasta."
        sudo mkdir $dir_server
        sudo chmod 7775 $dir_server/ -R
        sudo chown $user:www-data $dir_server/ -R
        sudo mkdir $dir_server/public_html
        echo "Consedendo permissões a public_html"
        sudo chmod 7777 $dir_server/public_html -R        
        sudo chown $user:www-data $dir_server/public_html -R
        echo "Criando pasta de Logs"
        sudo mkdir $dir_server/logs
        echo "Consedendo permissões a logs"
        sudo chmod 7777 $dir_server/logs -R
        sudo chown $user:www-data $dir_server/logs -R
        echo "Pasta criada com Sucesso!"        
    else
        if [ $dire="s" ];
        then
            sudo chmod 7775 $dir_server/ -R
            sudo chown $user:www-data $dir_server/ -R  
        fi
        echo "A pasta public_html já existe."
        echo "Consedendo permissões a public_html"
        sudo chmod 7777 $dir_server/public_html -R
        sudo chown $user:www-data $dir_server/public_html -R
        echo "Consedendo permissões a logs"
        sudo chmod 7777 $dir_server/logs -R
        sudo chown $user:www-data $dir_server/logs -R
        echo "Pasta criada com Sucesso!!"        
    fi
fi

echo "Reiniciando o $programa"
sudo /etc/init.d/$programa restart