# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  #config.vm.box = "bento/ubuntu-16.04"
  config.vm.box = "bento/centos-7.2"
  config.vm.provision "shell", path: "provision/prepare.sh"
  # set some names <=> ips inside all machines
  config.vm.provision :hosts do |h|
      # default servers for puppet agents and salt minions
      h.add_host '192.168.100.5', ['puppet']
      h.add_host '192.168.100.6', ['salt']
      h.add_host '192.168.100.7', ['ansible']
      h.add_host '192.168.100.8', ['manageiq']
      h.add_host '192.168.100.9', ['tower']
      h.add_host '192.168.100.11', ['m1.local', 'm1']
      h.add_host '192.168.100.12', ['m2.local', 'm2']
      h.add_host '192.168.100.13', ['m3.local', 'm3']
      h.add_host '192.168.100.21', ['w1.local', 'w1']
      h.add_host '192.168.100.22', ['w2.local', 'w2']
  end

  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "512"
  end

  #TODO: this + below runs puppet twice
  config.vm.provision "puppet" do |puppet|
    puppet.environment_path = "puppet/envs"
  end

  # we need to this so vagrant generates the ansible inventory for us
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/nothing.yml"
    ansible.groups = {
      "rabbits" => ["m[1:2]"]
    }
  end

  config.vm.define :cm do |cm|
    cm.vm.provider "virtualbox" do |vb|
       vb.memory = "2048"
    end
    cm.vm.hostname = "cmserver.local"
    cm.vm.network "private_network", ip: "192.168.100.5", virtualbox__intnet: "cmnet"
    #cm.vm.network "forwarded_port", guest: 80, host: 9080
    #cm.vm.network "forwarded_port", guest: 4440, host: 4440
    #cm.vm.provision "docker" do |d|
    #  d.run "redisio", daemonize: true, image: "redis"
    #  d.run "mongodb", daemonize: true, image: "mongo", args: "-p 127.0.0.1:27017:27017"
    #  d.run "semaphore", daemonize: true, image: "castawaylabs/semaphore", args: "--link redisio:redis --link mongodb:mongo -e MONGODB_URL='mongodb://mongo/semaphore' -e REDIS_HOST='redis' -p 80:80"
    #  d.run "rundeck", daemonize: true, image: "jordan/rundeck", args: "-p 4440:4440 -e SERVER_URL=http://127.0.0.1:4440 -v /opt/rundeck-plugins:/opt/rundeck-plugins"
    #end
  end

  config.vm.define :saltmaster do |cm2|
    cm2.vm.provider "virtualbox" do |vb|
       vb.memory = "1024"
    end
    cm2.vm.hostname = "saltmaster.local"
    cm2.vm.network "private_network", ip: "192.168.100.6", virtualbox__intnet: "cmnet"
    cm2.vm.synced_folder "salt/root/", "/srv/salt/"
    #cm2.vm.network "forwarded_port", guest: 80, host: 9080
    #cm2.vm.network "forwarded_port", guest: 4440, host: 4440
  end

  config.vm.define :ansiblecm do |cm3|
    cm3.vm.provider "virtualbox" do |vb|
       vb.memory = "1024"
    end
    #cm3.vm.provision "ansible" do |ansible|
    #  ansible.playbook = "ansible/ansible.yml"
    #end
    cm3.vm.hostname = "ansiblecm.local"
    cm3.vm.network "private_network", ip: "192.168.100.7", virtualbox__intnet: "cmnet"
    #cm3.vm.network "forwarded_port", guest: 80, host: 9080
    cm3.vm.network "forwarded_port", guest: 4440, host: 4440
  end

  config.vm.define :manageiq do |cm4|
    cm4.vm.box = "manageiq/euwe"
    cm4.vm.provider "virtualbox" do |vb|
       vb.memory = "6144"
       vb.cpus = "4"
    end
    cm4.vm.hostname = "manageiq.local"
    cm4.vm.network "private_network", ip: "192.168.100.8", virtualbox__intnet: "cmnet"
    cm4.vm.network "forwarded_port", guest: 443, host: 8444
  end

  config.vm.define :tower do |cm5|
    cm5.vm.box = "ansible/tower"
    cm5.vm.provider "virtualbox" do |vb|
       vb.memory = "1024"
    end
    cm5.vm.hostname = "tower.local"
    cm5.vm.network "private_network", ip: "192.168.100.9", virtualbox__intnet: "cmnet"
    cm5.vm.network "forwarded_port", guest: 443, host: 8443
    cm5.vm.boot_timeout = 600
  end

  # specify all these settings only once.
  config.vm.define :m1 do |m1|
    #m1.vm.provision "puppet" do |puppet|
    #  puppet.environment_path = "puppet/envs"
    #  puppet.manifests_path = "puppet/envs/production/manifests"
    #  puppet.manifest_file = "full.pp"
    #  puppet.hiera_config_path = "puppet/envs/production/hiera.yaml"
    #end
    m1.vm.hostname = "m1.local"
    m1.vm.network "private_network", ip: "192.168.100.11", virtualbox__intnet: "cmnet"
    m1.vm.network "forwarded_port", guest: 15672, host: 15672  # rabbitmq mgmt
  end
  config.vm.define :m2 do |m2|
    #m2.vm.provision "puppet" do |puppet|
    #  puppet.environment_path = "puppet/envs"
    #  puppet.manifests_path = "puppet/envs/production/manifests"
    #  puppet.manifest_file = "full.pp"
    #  puppet.hiera_config_path = "puppet/envs/production/hiera.yaml"
    #end
    m2.vm.hostname = "m2.local"
    m2.vm.network "private_network", ip: "192.168.100.12", virtualbox__intnet: "cmnet"
    m2.vm.network "forwarded_port", guest: 15672, host: 25672  # rabbitmq mgmt
  end
  config.vm.define :m3 do |m3|
    m3.vm.hostname = "m3.local"
    m3.vm.network "private_network", ip: "192.168.100.13", virtualbox__intnet: "cmnet"
  end

  config.vm.define :w1 do |w1|
    w1.vm.box = 'mwrock/Windows2016'
    w1.vm.hostname = "w1"
    w1.vm.communicator = "winrm"

    # Admin user name and password
    w1.winrm.username = "vagrant"
    w1.winrm.password = "vagrant"

    w1.vm.guest = :windows
    w1.windows.halt_timeout = 15

    w1.vm.network "private_network", ip: "192.168.100.21", virtualbox__intnet: "cmnet"
    w1.vm.network :forwarded_port, guest: 3389, host: 33389, id: "rdp", auto_correct: true

    w1.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
        config.vm.provider :virtualbox do |vb|
         vb.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "/home/morales/downloads/ISOs/14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO"]
       end
    end
  end
  config.vm.define :w2 do |w2|
    w2.vm.box = 'mwrock/Windows2016'
    w2.vm.hostname = "w2"
    w2.vm.communicator = "winrm"

    # Admin user name and password
    w2.winrm.username = "vagrant"
    w2.winrm.password = "vagrant"

    w2.vm.guest = :windows
    w2.windows.halt_timeout = 15

    w2.vm.network "private_network", ip: "192.168.100.22", virtualbox__intnet: "cmnet"
    w2.vm.network :forwarded_port, guest: 3389, host: 33390, id: "rdp", auto_correct: true

    w2.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
end
