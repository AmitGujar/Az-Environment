group=myLinuxResource
echo "\n Starting Resource Deletion.\n"

az group delete -g $group -y
status=true
if $status
then
    echo "Deleted myLinuxResource."
else 
    echo "Failed to delete."
fi

az group delete --name NetworkWatcherRG -y
status=true
if $status
then 
    echo "Deleted NetworkWatcherRG"
else 
    echo "Failed to Delete."
fi
