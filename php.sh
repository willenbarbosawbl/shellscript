#!/bin/bash

programa="php8.0"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

if [ -n "$pacote" ];
then
    echo "O programa ($programa) já está instalado!"
    echo "Verão do $programa"
    sudo php -v
    exit
else
    echo "Instalando o $programa"
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update -y
    sudo apt install php8.0 php8.0-intl php8.0-mysql php8.0-sqlite3 php8.0-gd -y
    echo "Verão do $programa"
    sudo php -v
    echo "Instalando complementos"
    sudo apt install libapache2-mod-php8.0 php8.0-fpm libapache2-mod-fcgid php8.0-curl -y 
    echo "Habilitando o PHP-FPM"
    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php8.0-fpm
    echo "Reiniciando o Apache2"
    sudo /etc/init.d/apache2 restart
fi

echo "$programa instalando com sucesso."
echo "Criando o arquivo info.php"
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

echo "<?php phpinfo(); ?>" >> $dir_server/public_html/info.php
echo "Tudo pronto? Acesse: http://localhost/info.php para testar"
