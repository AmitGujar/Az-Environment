group=myLoadBalancer

az group delete -g $group -y
status=true
if $status
then
    echo "\n ......Deleted myLoadBalancer Successfully...... \n"
else 
    echo "\n .......Operation Failed......."
fi

az group delete --name NetworkWatcherRG -y
status=true
if $status
then
    echo "\n ......Deleted NetWorkWatcherRG........... \n"
else 
    echo "\n ......Operation Failed......."
fi

az group delete --name cloud-shell-storage-centralindia -y
status=true
if $status
then 
    echo "\n ......Deleted Terminal Storage........"
else 
    echo "\n .......Storage resource doesn't exists........."
fi
az group list