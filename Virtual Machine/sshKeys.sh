#! /bin/bash
group=AmitRG

az sshkey create \
    -n "Laptop_Keys" \
    --public-key "@/home/amitdg/.windowSsh/windows.pub" \
    -g $group
