# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "public_network", bridge: "enp2s0"
  config.vbguest.auto_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: false


  (0..2).each do |i|
    config.vm.define "emma#{i}" do |node|
      node.vm.hostname = "emma#{i}.#{ENV['EMMA_DOMAIN']}"
      # GlusterFS storage disk
      node.persistent_storage.enabled = true
      node.persistent_storage.location = "emma#{i}-data.vdi"
      node.persistent_storage.size = 20000
      node.persistent_storage.mountname = 'data'
      node.persistent_storage.filesystem = 'xfs'
      node.persistent_storage.mountpoint = '/data/local'
      node.persistent_storage.volgroupname = 'data'
      # Xenial wrong disk fix, see https://github.com/kusnier/vagrant-persistent-storage/issues/59
      node.persistent_storage.diskdevice = '/dev/sdc'
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3196"
  end

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /root/.ssh
    cp /vagrant/emma.key /root/.ssh/id_rsa
    cp /vagrant/emma.key.pub /root/.ssh/id_rsa.pub
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
    apt-get update
    apt-get install -y python-dev
  SHELL

  #Hostmanager should be set to false so it runs after provisioning
  config.hostmanager.enabled = false
  config.hostmanager.manage_guest = true
  config.hostmanager.manage_host = false
  config.hostmanager.include_offline = false
  config.hostmanager.ignore_private_ip = true
  config.hostmanager.ip_resolver = proc do |machine|
    result = ""
    machine.communicate.execute("ifconfig enp0s8") do |type, data|
        result << data if type == :stdout
    end
    (ip = /inet addr:(\d+\.\d+\.\d+\.\d+)/.match(result)) && ip[1]
  end
  config.vm.provision :hostmanager

end
