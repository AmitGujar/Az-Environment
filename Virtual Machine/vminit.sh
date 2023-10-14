#!/bin/bash

size=$3
group=$2
instance=$1

if [ -z $instance ] || [ $instance -eq 0 ]; then
    read -p "How many machines you want to create? = " instance
else
    echo "Creating $instance machines."
fi

if [ -z $group ]; then
    read -p "Enter name for resource group = " group
else
    echo "Resource group name is provided, Using $group as resource group name."
fi

generate_keys() {
    if [ -f ~/.ssh/id_rsa ]; then
        echo "SSH keys already exist...."
        # rm -rf ~/.ssh
    else
        echo "Generating new ssh keys."
        yes "" | ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
    fi
}
# generate_keys

echo "Initializing VM Creation Process."

az group create -g $group -l centralindia 2>/dev/null
if [ $? -ne 0 ]; then
    az group create -g group -l centralindia
fi

tag_addition() {
    az group show -g $group | grep id | cut -d':' -f2 >>resource_id.txt
    resource_id=$(cat resource_id.txt | sed 's/["\,]//g')
    az tag create --resource-id $resource_id --tags Exp=3
    rm -rf resource_id.txt
}
tag_addition

az network vnet create \
    -n vm-net \
    -g $group \
    -l centralindia \
    --address-prefixes '192.168.0.0/16' \
    --subnet-name subnet \
    --subnet-prefixes '192.168.0.0/24'

if [ -z $size ]; then
    echo "No size is provided, Using default size Standard_B1s for machine"
    size=B1s
fi

vm_create() {
    for i in $(seq 1 $instance); do
        az vm create \
            -n Machine$i \
            -g $group \
            -l centralindia \
            --size Standard_$size \
            --image Ubuntu2204 \
            --admin-username amitgujar \
            --vnet-name vm-net \
            --subnet subnet \
            --public-ip-sku Standard \
            --generate-ssh-keys \
            --ssh-key-values ~/.ssh/id_rsa.pub

        az vm open-port -g $group -n Machine$i --port 80
    done
}
vm_create

update_vm() {
    for i in $(seq 1 $instance); do
        az vm run-command invoke \
            -g $group \
            -n Machine$i \
            --command-id RunShellScript \
            --script "sudo apt update -y"

    done
}

update_vm

vm_listIpAddress() {
    for i in $(seq 1 $instance); do
        az vm list-ip-addresses \
            -n Machine$i \
            -g $group | grep ipAddress | cut -d':' -f2
    done
}

vm_listIpAddress
