#!/bin/bash
#set -x
terraform init
terraform apply -auto-approve
#
# sleep 5

Count=5
while Count=>1;
do
  if $(terraform output | grep ssh) #"true"
  then
  break;
  else
  echo "ainda nao esta pronto para conexão, nova tentativa em 2 segundos..."
  sleep 2
  Count=Count-1
  fi;
done
