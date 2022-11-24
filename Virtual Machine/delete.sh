group=myLinuxResource
echo "\n Starting Resource Deletion.\n"

az group delete -g $group -y
status=true
if $status
then
    echo "\n Deleted myLinuxResource.\n"
else 
    echo "\n Failed to delete.\n"
fi

az group delete --name NetworkWatcherRG -y
status=true
if $status
then 
    echo "\n Deleted NetworkWatcherRG.\n"
else 
    echo "\n Failed to Delete.\n"
fi