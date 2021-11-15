#!/bin/bash

programa="php8.0"
pacote=$(dpkg -l | grep "$programa")

sudo apt remove --purge php8.0* php-common -y
sudo rm -rf /etc/php
sudo apt autoremove --purge -y