#!/bin/bash
echo "Configurando IP Fixo netplan"
echo "Criando backup do arquivo original"
RANDOM=$(date +%s)
sudo /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.$RANDOM.bkp
echo "Removendo arquivo original"
rm -rf /etc/netplan/00-installer-config.yaml
echo "Qual é o nome da placa de rede? "
read nomerede
echo "Qual é o endereço ip? exemplo: 192.168.0.2/24 "
read ip
echo "Quais são os endereços dns? exemplo: 8.8.8.8,8.8.4.4 "
read dns
echo "Qual é o ip de gateway? exemplo: 192.168.0.1 "
read gateway
echo "network:" >> /etc/netplan/00-installer-config.yaml
echo " renderer: networkd" >> /etc/netplan/00-installer-config.yaml
echo " version: 2" >> /etc/netplan/00-installer-config.yaml
echo " ethernets:" >> /etc/netplan/00-installer-config.yaml
echo "  $nomerede:" >> /etc/netplan/00-installer-config.yaml
echo "   addresses:" >> /etc/netplan/00-installer-config.yaml
echo "    - $ip" >> /etc/netplan/00-installer-config.yaml
echo "   nameservers:" >> /etc/netplan/00-installer-config.yaml
echo "    addresses: [$dns]" >> /etc/netplan/00-installer-config.yaml
echo "   routes:" >> /etc/netplan/00-installer-config.yaml
echo "    - to: default" >> /etc/netplan/00-installer-config.yaml
echo "      via: $gateway" >> /etc/netplan/00-installer-config.yaml
echo "Visualizando configurações feitas"
sudo nano /etc/netplan/00-installer-config.yaml
echo "Aplicando configurações"
sudo netplan --debug apply
