#!/bin/bash
#set -x
terraform apply -auto-approve
#
# sleep 5

Count=0
while Count=<5;
do
  if $(terraform output | grep ssh) #"true"
  then
  break;
  else
  sleep 1
  echo "ainda nao esta pronto para conexão"
  Count=Count+1
  fi;
done
