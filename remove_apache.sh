#!/bin/bash

programa="apache2"

echo "Removendo o $programa..."
sudo apt remove --purge $programa* -y
echo "Removendo pasta de configuração"
sudo rm -rf /etc/$programa