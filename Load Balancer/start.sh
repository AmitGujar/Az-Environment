group=myLoadBalancer

rm -r ~/.ssh
echo "\n Generating new ssh keys.\n"
ssh-keygen -m PEM -t rsa -b 4096
# creating resource group for load balancer
az group create -g $group -l centralindia

echo "\nInitializing Virtual Network Creation Process.\n"
# creating virtual network
az network vnet create \
  -n vm-vnet \
  -g $group \
  -l centralindia \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'

# setting up availability set
az vm availability-set create \
  -n vm-as \
  -l centralindia \
  -g $group

echo "\nInitializing VM Creation Process.\n"
# creating 2 virtual machines
for NUM in 1 2; do
  az vm create \
    -n machine$NUM \
    -g $group \
    -l centralindia \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --vnet-name vm-vnet \
    --subnet subnet \
    --availability-set vm-as \
    --nsg vm-nsg \
    --generate-ssh-keys \
    --ssh-key-values ~/.ssh/id_rsa.pub
done

# opening port 80
for NUM in 1 2; do
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

az vm run-command invoke \
  -g $group \
  -n Machine1 \
  --command-id RunShellScript \
  --script "sudo su" \
  --script "echo \"<h1>Server Started</h1>\" >> "/var/www/html/index.nginx-debian.html"