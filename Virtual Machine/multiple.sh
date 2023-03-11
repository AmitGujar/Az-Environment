group=myLinuxResource

rm -r ~/.ssh
echo "\n Generating new ssh keys.\n"
ssh-keygen -m PEM -t rsa -b 4096

echo "\nInitializing VM Creation Process.\n"
az group create -g $group -l centralindia

# creating virtual network
az network vnet create \
  -n vm-vnet \
  -g $group \
  -l centralindia \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'

az vm availability-set create \
  -n vm-as \
  -l centralindia \
  -g $group

# E2ds_v4
az vm create \
  -n masternode \
  -g $group \
  -l centralindia \
  --size Standard_B1s \
  --image UbuntuLTS \
  --admin-username amitgujar \
  --vnet-name vm-net \
  --subnet subnet \
  --public-ip-sku Standard \
  --generate-ssh-keys \
  --ssh-key-values ~/.ssh/id_rsa.pub
  
#D2ds_v4
# creating 2 virtual machines
az vm create \
  -n workernode \
  -g $group \
  -l centralindia \
  --size Standard_B1s \
  --image UbuntuLTS \
  --admin-username amitgujar \
  --vnet-name vm-vnet \
  --subnet subnet \
  --public-ip-sku Standard \
  --generate-ssh-keys \
  --nsg vm-nsg \
  --ssh-key-values ~/.ssh/id_rsa.pub

az vm open-port -g $group --name masternode --port 80


# az vm open-port -g $group --name masternode --port 6443
# az vm open-port -g $group --name masternode --port 8472
# az vm open-port -g $group --name masternode --port 10250
# az vm open-port -g $group --name masternode --port 51820
# az vm open-port -g $group --name masternode --port 51821

# opening port 80
az vm open-port -g $group --name workernode --port 80
# az vm open-port -g $group --name workernode --port 8472
# az vm open-port -g $group --name workernode --port 10250
# az vm open-port -g $group --name workernode --port 51820
# az vm open-port -g $group --name workernode --port 51821