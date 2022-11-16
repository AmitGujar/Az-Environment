group=myLoadBalancer

az network public-ip create \
  -g $group \
  --name myPublicIP

az network lb create \
  -g $group \
  --name myLoadBalancer \
  --public-ip-address myPublicIP \
  --frontend-ip-name myFrontEnd \
  --backend-pool-name myBackendPool 

az network lb probe create \
  -g $group \
  --lb-name myLoadBalancer \
  --name myHealthProbe \
  --protocol tcp \
  --port 80 

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
  --idle-timeout 15 