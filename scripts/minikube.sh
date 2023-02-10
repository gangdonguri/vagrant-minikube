export KUBERNETES_VERSION="1.16.3"

# Install conntrack
echo "===Downloading Conntrack==="
sudo apt install -y conntrack

# Install minikube
echo "===Downloading minikube==="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

#Setup minikube
echo "===Setup minikube==="
echo "127.0.0.1 minikube minikube." | sudo tee -a /etc/hosts
mkdir -p $HOME/.minikube
mkdir -p $HOME/.kube
touch $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Permissions
echo "===Export ENV==="
sudo chown -R $USER:$USER $HOME/.kube
sudo chown -R $USER:$USER $HOME/.minikube
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$HOME/.kube/config

# Disable SWAP since is not supported on a kubernetes cluster
echo "===Swap Off==="
sudo swapoff -a

# Start minikube
echo "===Start minikube==="
minikube start -v 4 --vm-driver docker --kubernetes-version v${KUBERNETES_VERSION} --bootstrapper kubeadm

# Addons
echo "===Addon enable==="
minikube addons enable ingress

# Configure vagrant clients dir
echo "===Configure vagrant clients directory==="
printf "export MINIKUBE_WANTUPDATENOTIFICATION=false\n" >> /home/vagrant/.bashrc
printf "export MINIKUBE_WANTREPORTERRORPROMPT=false\n" >> /home/vagrant/.bashrc
printf "export MINIKUBE_HOME=/home/vagrant\n" >> /home/vagrant/.bashrc
printf "export CHANGE_MINIKUBE_NONE_USER=true\n" >> /home/vagrant/.bashrc
printf "export KUBECONFIG=/home/vagrant/.kube/config\n" >> /home/vagrant/.bashrc
printf "alias kubectl='minikube kubectl --'\n" >> /home/vagrant/.bashrc
printf "source <(kubectl completion bash)\n" >> /home/vagrant/.bashrc

# Permissions
sudo chown -R $USER:$USER $HOME/.kube
sudo chown -R $USER:$USER $HOME/.minikube

# Enforce sysctl
echo "===Configure sysctl==="
sudo sysctl -w vm.max_map_count=262144
sudo echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.d/90-vm_max_map_count.conf
