group=AmitRG
size=$1

read -p "How many machines you want to create? = " instance

if [ -z $instance ] || [ $instance -eq 0 ]; then 
    echo "\nNo size is provided, Please specify the size and Try Again."
    exit 1
fi

generate_keys() {
    if [ -f ~/.ssh/id_rsa ]; then
        echo "SSH keys already exist, Deleting...."
        rm -rf ~/.ssh
    fi
    
    echo "\n Generating new ssh keys.\n"
    yes "" | ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
}
generate_keys

echo "\nInitializing VM Creation Process.\n"

az group create -g $group -l centralindia 2> /dev/null
if [ $? -ne 0 ]; then
    az group create -g group -l centralindia
fi

# groupid=/subscriptions/4086ee36-d2b5-4797-adef-ad1144340909/resourceGroups/AmitRG 
# groupid=/subscriptions/052c9332-2138-411f-adef-e7445d02ecc6/resourceGroups/AmitRG
# az tag create --resource-id $groupid --tags Exp=7 Status=Normal

az network vnet create \
    -n vm-net \
    -g $group \
    -l centralindia \
    --address-prefixes '192.168.0.0/16' \
    --subnet-name subnet \
    --subnet-prefixes '192.168.0.0/24'

if [ -z $size ]; then 
	echo "\nNo size is provided, Using default size Standard_B1s for machine"
	size=B1s
fi

vm_create() {
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
    
    az vm open-port -g $group -n Machine$i --port 80
done
}
vm_create

update_vm() {
for i in $(seq 1 $instance);
do 
    az vm run-command invoke \
        -g $group \
        -n Machine$i \
        --command-id RunShellScript \
        --script "sudo apt update -y" 

done
}

update_vm

az vm list-ip-addresses -n Machine1 -g AmitRG | grep ipAddress | cut -d':' -f2

sh ./connect.sh

# az vm disk attach \
#     --vm-name Machine1 \
#     --name Machine1_disk --new \
#     -g $group \
#     --sku Premium_LRS \
#     --caching None \
#     --size-gb 32 
