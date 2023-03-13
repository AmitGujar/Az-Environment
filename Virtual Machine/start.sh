group=myLinuxResource
size=$1

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

#sleep 3

#echo "What is the image size of the Virtual Machine = "
#read size

if [ -z $size ]; then 
	echo "\nNo size is provided, Using default size Standard_B1s for machine"
	size=B1s
fi

az vm create \
    -n Machine1 \
    -g $group \
    -l centralindia \
    --size Standard_$size \
    --image UbuntuLTS \
    --admin-username amitgujar \
    --vnet-name vm-net \
    --subnet subnet \
    --generate-ssh-keys \
    --ssh-key-values ~/.ssh/id_rsa.pub \

az vm open-port -g $group --name Machine1 --port 80

#az vm disk attach \
#   --vm-name Machine1 \
#    --name Machine1_disk --new \
#   -g $group \
#    --sku Premium_LRS \
#    --caching None \
#    --size-gb 32 \

#az vm run-command invoke \
#    -g $group \
#    -n Machine1 \
#    --command-id RunShellScript \
#    --script "sudo apt-get update || upgrade && sudo apt install fio -y"

status=true
if $status
then 
    echo "\n Virtual Machine has been created successfully. && Standard SSD is attached"
else
    echo "\n Operation Failed."
fi
