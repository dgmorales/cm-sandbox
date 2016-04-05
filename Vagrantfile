# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell", path: "provision/cm-install.sh"

  config.vm.define :cm do |cm|
    cm.vm.hostname = "cmserver.local"
    cm.vm.network "private_network", ip: "192.168.100.5", virtualbox__intnet: "cmnet"
  end
  config.vm.define :m1 do |m1|
    m1.vm.hostname = "m1.local"
    m1.vm.network "private_network", ip: "192.168.100.11", virtualbox__intnet: "cmnet"
  end
  config.vm.define :m2 do |m2|
    m2.vm.hostname = "m2.local"
    m2.vm.network "private_network", ip: "192.168.100.12", virtualbox__intnet: "cmnet"
    m2.vm.provision :hosts do |provisioner|
      provisioner.add_host '192.168.100.50', ['puppet', 'salt']
    end
  end
  config.vm.define :m3 do |m3|
    m3.vm.hostname = "m3.local"
    m3.vm.network "private_network", ip: "192.168.100.13", virtualbox__intnet: "cmnet"
  end

  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "384"
  end
end
