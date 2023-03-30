group=AmitRG

read -p "How many NAT rule you want to create? = " instance

# Setting up public ip for load balancer
az network public-ip create \
  -g $group \
  --name myPublicIP

# Initializing the Load Balancer
az network lb create \
  -g $group \
  --name myLoadBalancer \
  --sku Standard \
  --public-ip-address myPublicIP \
  --frontend-ip-name myFrontEnd \
  --backend-pool-name myBackendPool 

# creating health probe
az network lb probe create \
  -g $group \
  --lb-name myLoadBalancer \
  --name myHealthProbe \
  --protocol tcp \
  --port 80 

# creating load balancer rule
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

# configuring the ip for both nic of vms
az network nic ip-config address-pool add \
  --address-pool myBackendPool \
  --ip-config-name ipconfigmachine1 \
  --nic-name machine1VMNic \
  -g $group \
  --lb-name myLoadBalancer

az network nic ip-config address-pool add \
  --address-pool myBackendPool \
  --ip-config-name ipconfigmachine2 \
  --nic-name machine2VMNic \
  -g $group \
  --lb-name myLoadBalancer


for i in $(seq 1 $instance); 
do 
  az network lb inbound-nat-rule create \
    -g $group \
    --lb-name myLoadBalancer \
    -n MyNatRule$i \
    --protocol Tcp \
    --frontend-port 400$i \
    --backend-port 22 \
    --frontend-ip myFrontEnd     
done

az network lb frontend-ip list \
  --lb-name myLoadBalancer \
  -g $group