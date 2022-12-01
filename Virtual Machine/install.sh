echo "\nRunning as root\n"

ufw disable

swapoff -a; sed -i '/swap/d' /etc/fstab

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

echo "\n Reboot your system \n"

echo "\n Installing Docker\n"

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "\nDocker official key has been added"

echo "\n Setting up docker repository \n"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

apt-cache madison docker-ce | awk '{ print $3 }'

apt install -y docker-ce=5:19.03.10~3-0~ubuntu-bionic containerd.io

echo "\nDocker installation is successful."

echo "\n Setting up Kubernetes \n"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list



echo "\n Kubernetes has been installed successfully."

echo "\n Specify Container Runtime\n"
Environment="cgroup-driver=systemd/cgroup-driver=cgroupfs"


echo "\n Initializing Cluster \n"

kubeadm init --apiserver-advertise-address=4.240.59.107 --pod-network-cidr=192.168.0.0/16  --ignore-preflight-errors=all