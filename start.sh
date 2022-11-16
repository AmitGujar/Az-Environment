group=myLoadBalancer
az group create -g $group -l northeurope

az network vnet create \
  -n vm-vnet \
  -g $group \
  -l northeurope \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24' 
  
az vm availability-set create \
  -n vm-as \
  -l northeurope \
  -g $group 

for NUM in 1 2
do
  az vm create \
    -n machine$NUM \
    -g $group \
    -l northeurope \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --vnet-name vm-vnet \
    --subnet subnet \
    --availability-set vm-as \
	  --nsg vm-nsg 
done

for NUM in 1 2
do
  az vm open-port -g $group --name machine$NUM --port 80 
done

for NUM in 1 2 
do
  az vm run-command invoke \
    -g $group \
    -n machine$NUM \
    --command-id RunShellScript \
    --script "sudo apt-get update || upgrade && sudo apt install nginx -y"
done