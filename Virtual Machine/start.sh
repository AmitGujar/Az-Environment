group=AmitRG
size=$1
groupid=/subscriptions/9d08fcd9-b6df-4a2f-9697-0414d8838111/resourceGroups/AmitRG

rm -r ~/.ssh
echo "\n Generating new ssh keys.\n"
ssh-keygen -m PEM -t rsa -b 4096

echo "\nInitializing VM Creation Process.\n"
az group create -g $group -l centralindia

az tag create --resource-id $groupid --tags Exp=7 Status=Normal

az network vnet create \
    -n vm-net \
    -g $group \
    -l centralindia \
    --address-prefixes '192.168.0.0/16' \
    --subnet-name subnet \
    --subnet-prefixes '192.168.1.0/24'

if [ -z $size ]; then 
	echo "\nNo size is provided, Using default size Standard_B1s for machine"
	size=B1s
fi

read -p "How many machines you want to create? = " instance

if [ $instance==0 ]; then 
    echo "\nNo size is provided, Creating default 1 Machine"
    instance=1
fi

for i in $(seq 1 $instance);
do 
 az vm create \
   -n Machine$i \
   -g $group \
   -l centralindia \
   --size Standard_$size \
   --image UbuntuLTS \
   --admin-username amitgujar \
   --vnet-name vm-net \
   --subnet subnet \
   --public-ip-sku Standard \
   --generate-ssh-keys \
   --ssh-key-values ~/.ssh/id_rsa.pub 
done

# az vm open-port -g $group --name Machine1 --port 80
for i in $(seq 1 $instance);
do
    az vm open-port -g $group -n Machine$i --port 80
done

for i in $(seq 1 $instance);
do 
    az vm run-command invoke \
     -g $group \
     -n Machine$i
     --command-id RunShellScript \
     --script "sudo apt update -y" 
done

# az vm create \
#     -n Machine1 \
#     -g $group \
#     -l centralindia \
#     --size Standard_$size \
#     --image UbuntuLTS \
#     --admin-username amitgujar \
#     --vnet-name vm-net \
#     --subnet subnet \
#     --generate-ssh-keys \
#     --ssh-key-values ~/.ssh/id_rsa.pub \

#az vm disk attach \
#   --vm-name Machine1 \
#    --name Machine1_disk --new \
#   -g $group \
#    --sku Premium_LRS \
#    --caching None \
#    --size-gb 32 \