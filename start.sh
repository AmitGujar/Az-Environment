group=myLoadBalancer
az group create -g $group -l northeurope

az network vnet create \
  -n vm-vnet \
  -g $group \
  -l northeurope \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'

az network public-ip create \
  -g $group \
  --name myPublicIP
  
az vm availability-set create \
  -n vm-as \
  -l northeurope \
  -g $group \


az network lb create \
  -g $group \
  --name myLoadBalancer \
  --public-ip-address myPublicIP \
  --frontend-ip-name myFrontEnd \
  --backend-pool-name myBackendPool \

az network lb probe create \
  -g $group \
  --lb-name myLoadBalancer \
  --name myHealthProbe \
  --protocol tcp \
  --port 80 \

az network lb rule create \
  -g $group \
  --lb-name myLoadBalancer \
  --name myHTTPRule \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name myFrontEnd \
  --backend-pool-name myBackendPool \
  --probe-name myHealthProbe \
  --disable-outbound-snat true \
  --idle-timeout 15 \


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
	  --nsg vm-nsg \
done

for NUM in 1 2
do
  az vm open-port -g $group --name machine$NUM --port 80 
done