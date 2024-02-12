## Use these scripts to automate tasks on Microsoft Azure
test

### Use Virtual Machine folder to create the no. of machines with desired image size.

```
./start.sh [size of vm] 

./start.sh D2s_v3
```
If you want to go with the default values 
```
curl https://raw.githubusercontent.com/AmitGujar/Az-Environment/main/Virtual%20Machine/vminit.sh | bash
```

### Use Load Balancer script to create public basic load balancer in azure.

Run start.sh to create 2 vms with nginx server.

Make changes in both server files.

Run load.sh to create load balancer.

Run delete.sh to clean all resources..

this line is added for test
