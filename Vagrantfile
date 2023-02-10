# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 2.0.0"

require './vagrant-provision-reboot-plugin'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
  config.vm.box = "generic/ubuntu1804"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.define "minikube" do |minikube|
    minikube.vm.hostname = "minikube"
    minikube.vm.provider "virtualbox" do |vb|
      vb.name = "minikube"
      vb.memory = 4096
      vb.cpus =  2
    end
    minikube.vm.provision "bootstrap", type: "shell", path: "./scripts/bootstrap.sh"
    minikube.vm.provision "common", type: "shell", path: "./scripts/common.sh"
    minikube.vm.provision "docker", type: "shell", path: "./scripts/docker.sh", privileged: false
    minikube.vm.provision :unix_reboot
    minikube.vm.provision "minikube", type: "shell", path: "./scripts/minikube.sh", privileged: false
    minikube.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: "tcp"
    minikube.vm.network "private_network", ip: "10.0.0.10"
  end
end
