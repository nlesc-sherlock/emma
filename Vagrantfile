# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "public_network", bridge: "enp2s0"

  (0..2).each do |i|
    config.vm.define "emma#{i}" do |node|
      node.vm.hostname = "emma#{i}.#{ENV['EMMA_DOMAIN']}"
      # GlusterFS storage disk
      node.persistent_storage.enabled = true
      node.persistent_storage.location = "emma#{i}-data.vdi"
      node.persistent_storage.size = 20000
      node.persistent_storage.mountname = 'brick1'
      node.persistent_storage.filesystem = 'xfs'
      node.persistent_storage.mountpoint = '/data/brick1'
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
end
