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

az vm create \
  -n MasterNode \
  -g $group \
  -l centralindia \
  --size Standard_E2ds_v4 \
  --image UbuntuLTS \
  --admin-username amitgujar \
  --vnet-name vm-net \
  --subnet subnet \
  --public-ip-sku Standard \
  --generate-ssh-keys \
  --ssh-key-values ~/.ssh/id_rsa.pub

# creating 2 virtual machines
for NUM in 1 2; do
  az vm create \
    -n WorkerNode$NUM \
    -g $group \
    -l centralindia \
    --size Standard_E2ds_v4 \
    --image UbuntuLTS --admin-username amitgujar \
    --vnet-name vm-vnet \
    --subnet subnet \
    --public-ip-sku Standard \
    --generate-ssh-keys \
    --nsg vm-nsg \
    --ssh-key-values ~/.ssh/id_rsa.pub
done

az vm open-port -g $group --name MasterNode --port 80

# opening port 80
for NUM in 1 2; do
  az vm open-port -g $group --name WorkerNode$NUM --port 80
done
