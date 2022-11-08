group=myLoadBalancer
az group delete -g $group -y
az group delete --name NetworkWatcherRG -y
az group list