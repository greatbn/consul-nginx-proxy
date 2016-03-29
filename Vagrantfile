# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update
     sudo apt-get install -y whois git
     sudo useradd -m -p `mkpasswd password` -s /bin/bash saphi
     sudo usermod -a -G sudo saphi
  SHELL

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.define "node-one" do |n1|
      n1.vm.hostname = "node-one"
      n1.vm.network "private_network", ip: "10.30.0.10"
      n1.vm.provision :shell, path: "node-one/run.sh"
  end

  config.vm.define "node-two" do |n2|
      n2.vm.hostname = "node-two"
      n2.vm.network "private_network", ip: "10.30.0.11"
      n2.vm.provision :shell, path: "node-two/run.sh"
  end
  
  config.vm.define "proxy" do |gateway|
      gateway.vm.hostname = "proxy"
      gateway.vm.network "private_network", ip: "10.30.0.2"
      gateway.vm.provision :shell, path: "proxy/run.sh"
  end
end
