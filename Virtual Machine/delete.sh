group=AmitRG

echo "\nResource deletion may take a while..."

az group delete -g $group -y 2> /dev/null

resource_delete() {
    if [ $? -ne 0 ]; then
        echo "Failed to delete the resource $group"
        exit 1
    else
        echo "Resource deleted successfully"
    fi
}
resource_delete

group=NetworkWatcherRG
az group delete --name NetworkWatcherRG -y 2> /dev/null
resource_delete