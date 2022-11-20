group=myLoadBalancer

# creating resource group for load balancer
az group create -g $group -l northeurope

# creating virtual network
az network vnet create \
  -n vm-vnet \
  -g $group \
  -l northeurope \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24' 

# setting up availability set
az vm availability-set create \
  -n vm-as \
  -l northeurope \
  -g $group 

# creating 2 virtual machines
for NUM in 1 2
do
  az vm create \
    -n machine$NUM \
    -g $group \
    -l northeurope \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --vnet-name vm-vnet \
    --subnet subnet \
    --availability-set vm-as \
	  --nsg vm-nsg \
    # --generate-ssh-keys 
    --ssh-key-value ~/.ssh/id_rsa.pub
done

# opening port 80 
for NUM in 1 2
do
  az vm open-port -g $group --name machine$NUM --port 80 
done

# installing nginx in vms
for NUM in 1 2 
do
  az vm run-command invoke \
    -g $group \
    -n machine$NUM \
    --command-id RunShellScript \
    --script "sudo apt-get update || upgrade && sudo apt install nginx -y"
done