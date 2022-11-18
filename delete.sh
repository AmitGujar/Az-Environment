group=myLoadBalancer
az group delete -g $group -y
az group delete --name NetworkWatcherRG -y
az group delete --name cloud-shell-storage-centralindia -y
az group list
