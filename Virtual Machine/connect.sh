connection() {
    group=AmitRG
    username=amitgujar
    publicip=$(az vm list-ip-addresses -n Machine1 -g $group --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -o tsv)
    echo "Use this string to connect with virtual machine"
    echo "ssh $username@$publicip"
}
connection
