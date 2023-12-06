#!/bin/bash

stname="acistorage$RANDOM"

read -p "Enter the resource group name: " group

create_rg() {
  echo "creating resource group....."
  az group create -n $group -l centralindia
  resource_id=$(az group show -g $group --query id -o tsv)
  az tag create --resource-id $resource_id --tags "Exp=5"
}

if [ -z "$group" ]
then
  echo "resource group name not provided, using default name"
  group=rg-test-001
  create_rg
fi

# creating storage account
storage_account() {
  az storage account create \
    -n $stname \
    -g $group \
    -l centralindia \
    --sku Standard_LRS \
    --kind StorageV2 \
    --enable-large-file-share 
}
storage_account

storageKey=$(az storage account keys list -n $stname -g $group --query '[0].value' -o tsv)

# setting up azure file share
azure_file_share() {
  az storage share create \
    -n custom \
    --account-name $stname \
    --account-key $storageKey \
    --quota 30 
}
azure_file_share

echo "creating azure container instance..."

neo4j_container() {
  az container create \
    -g $group \
    -n neo4j-amundsen \
    --image amitgujar/neo4j:latest \
    --ports 7474 7687 \
    --cpu 3 \
    --memory 6 \
    --environment-variables TINI_SUBREAPER=true \
    --azure-file-volume-account-name $stname \
    --azure-file-volume-account-key $storageKey \
    --azure-file-volume-share-name custom \
    --azure-file-volume-mount-path /data \
    --ip-address public \


  echo "neo4j-amundsen container created"
}

elastic_container() {
  az container create \
    -g $group \
    -n es-amundsen \
    --image amitgujar/elastic:latest \
    --ports 9200 \
    --cpu 3 \
    --memory 6 \
    --azure-file-volume-account-name $stname \
    --azure-file-volume-account-key $storageKey \
    --azure-file-volume-share-name custom \
    --azure-file-volume-mount-path /usr/share/elasticsearch/data \
    --ip-address public \


  echo "elastic-amundsen container created"
}

neo4j_container
elastic_container
