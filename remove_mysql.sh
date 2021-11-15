#!/bin/bash

programa="mysql-server"

sudo apt remove --purge $programa* -y
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt autoremove -y
sudo apt autoremove --purge -y
