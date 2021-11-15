#!/bin/bash
caminho=/home/willenbarbosa/Documentos/
echo $caminho
if [ ! -d "$caminho" ]; then
    echo "Pasta não exite"
else
    echo "Pasta existe"
fi