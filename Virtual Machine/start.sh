group=myLinuxResource
rm -r ~/.ssh
echo "\n Generating new ssh keys.\n"
ssh-keygen -m PEM -t rsa -b 4096

echo "\nInitializing VM Creation Process.\n"
az group create -g $group -l centralindia

az network vnet create \
    -n vm-net \
    -g $group \
    -l centralindia \
    --address-prefixes '192.168.0.0/16' \
    --subnet-name subnet \
    --subnet-prefixes '192.168.1.0/24'

for NUM in 1 2 3
do
  az vm create \
    -n Machine$NUM \
    -g $group \
    -l centralindia \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --vnet-name vm-net \
    --subnet subnet \
    --generate-ssh-keys \
    --ssh-key-values ~/.ssh/id_rsa.pub \
done

for NUM in 1 2 3 
do
    az vm open-port -g $group --name Machine$NUM --port 80
done
# status=true

# if $status
# then 
#     echo "\n Virtual Machine has been created successfully."
# else
#     echo "\n Operation Failed."
# fi