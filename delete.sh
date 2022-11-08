group=myLoadBalancer
az group delete -g $group
az group delete --name NetworkWatcherRG -y