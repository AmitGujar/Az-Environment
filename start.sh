group = myLoadBalancer
az group create -g $group northeurope

az network vnet create \
    -n myVnet
    -g $group
    -l northeurope
    --address-prefixes '192.168.0.0/16' \
    --subnet-name subnet \
    --subnet-prefixes '192.168.1.0/24' \

az vm availability-set create \
    -n vm-as \
    -l northeurope \
    -g $group