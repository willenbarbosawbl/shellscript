#!/bin/bash

programa="phpmyadmin"
pacote=$(dpkg -l | grep "$programa")

sudo apt remove --purge phpmyadmin -y
sudo rm -rf /etc/phpmyadmin
sudo apt autoremove --purge -y