#!/bin/bash

source $HOME/Desktop/Az-Environment/Virtual\ Machine/ntfy_alert.sh

read -p "Enter the resource group name to delete = "  group

echo "Resource deletion may take a while..."

delete_status=$(az group delete -g $group -y)

resource_delete() {
    if [ ! $delete_status ]; then
        echo "Resource group $group deleted successfully..."

        send_alert "Resource group $group deleted successfully ✅"
    else
        echo "$group not found..."
        exit 1
    fi
}
resource_delete
# group=NetworkWatcherRG
# az group delete --name NetworkWatcherRG -y --no-wait 2> /dev/null
# resource_delete
