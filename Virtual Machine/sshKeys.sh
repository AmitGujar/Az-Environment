#! /bin/bash
group=AmitRG

az sshkey create \
    -n "Laptop_Keys" \
    --public-key "@/home/amitdg/.windowsKey/windows.pub" \
    -g $group
