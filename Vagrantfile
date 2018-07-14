# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'getoptlong'

opts = GetoptLong.new(
  [ '--network-type', GetoptLong::OPTIONAL_ARGUMENT ]
)

networkType='public_network'

opts.each do |opt, arg|
  case opt
    when '--network-type'
      networkType=arg
  end
end

module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

is_windows_host = "#{OS.windows?}"
puts "is_windows_host: #{OS.windows?}"
if OS.windows?
    puts "Vagrant launched from windows."
elsif OS.mac?
    puts "Vagrant launched from mac."
elsif OS.unix?
    puts "Vagrant launched from unix."
elsif OS.linux?
    puts "Vagrant launched from linux."
else
    puts "Vagrant launched from unknown platform."
end

puts "Vagrant will use a #{networkType}."

if "#{networkType}" != "public_network" and "#{networkType}" != "private_network"
    puts "--network-type should be either public_network or private_network."
    exit()
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  if "#{networkType}" != "private_network"
    config.vm.network "public_network"
  else
    config.vm.network "private_network", type: "dhcp"
    config.vm.network "forwarded_port", guest: 9091, host: 9091, host_ip: "127.0.0.1", auto_correct: true, id: "minio"
    config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1", auto_correct: true, id: "spark_master"
    config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "127.0.0.1", auto_correct: true, id: "jupyterhub"
  end
  config.vm.provision "shell", inline: <<-SHELL
    #disable ipv6
    echo "disabling ipv6"
    sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
  SHELL

  #Check if there is a new update for the box
  config.vm.box_check_update = true
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vbguest.auto_update = true
  vbox = VagrantPlugins::ProviderVirtualBox::Driver::Meta.new
  vbox_version = vbox.version

  if Vagrant::VERSION =~ /1.9.[0-9]/ && vbox_version =~ /5.1.[0-9]/
    puts "VB version is: %s" % [vbox_version]
    puts "Vagrant version is: %s" % [Vagrant::VERSION]
    puts "Disable synced_folder"
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox", disabled: true
  else
    puts "VB version is: %s" % [vbox_version]
    puts "Vagrant version is: %s" % [Vagrant::VERSION]
    config.vm.synced_folder ".", "/vagrant", type: "virtualbox", disabled: false
  end

  num_hosts = Integer("#{ENV['NUM_HOSTS']}")
  puts "Number of hosts is %s" % num_hosts
  num_hosts = Integer("#{ENV['NUM_HOSTS']}")-1
  (0..num_hosts).each do |i|
    config.vm.define "#{ENV['CLUSTER_NAME']}#{i}" do |node|
      node.vm.hostname = "#{ENV['CLUSTER_NAME']}#{i}.#{ENV['HOST_DOMAIN']}"
      # GlusterFS storage disk
      node.persistent_storage.enabled = true
      node.persistent_storage.location = "#{ENV['CLUSTER_NAME']}#{i}-data.vdi"
      node.persistent_storage.size = 80000
      node.persistent_storage.mountname = 'data'
      node.persistent_storage.filesystem = 'xfs'
      node.persistent_storage.mountpoint = '/data/local'
      node.persistent_storage.volgroupname = 'data'
      # Xenial wrong disk fix, see https://github.com/kusnier/vagrant-persistent-storage/issues/59
      node.persistent_storage.diskdevice = '/dev/sdc'
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "#{ENV['MEM_SIZE']}"
  end

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  puts "Copy ssh keys by hand."
  config.vm.provision "file", source: "./files/#{ENV['CLUSTER_NAME']}.key", destination: "/tmp/#{ENV['CLUSTER_NAME']}.key"
  config.vm.provision "file", source: "./files/#{ENV['CLUSTER_NAME']}.key.pub", destination: "/tmp/#{ENV['CLUSTER_NAME']}.key.pub"
  config.vm.provision "shell", inline: <<-SHELL
  mkdir -p /vagrant
  cp /tmp/#{ENV['CLUSTER_NAME']}.key /vagrant/
  cp /tmp/#{ENV['CLUSTER_NAME']}.key.pub /vagrant/
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /root/.ssh
    cp /vagrant/#{ENV['CLUSTER_NAME']}.key /root/.ssh/id_rsa
    cp /vagrant/#{ENV['CLUSTER_NAME']}.key.pub /root/.ssh/id_rsa.pub
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    cat /root/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
    apt-get update
    apt-get install -y python-dev
  SHELL

  #Hostmanager should be set to false so it runs after provisioning
  config.hostmanager.enabled = false
  config.hostmanager.manage_guest = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = false
  config.hostmanager.ignore_private_ip = true
  config.hostmanager.ip_resolver = proc do |machine|
    result = ""
    machine.communicate.execute("hostname -I") do |type, data|
        result << data if type == :stdout
    end
    ip = result.split[1]
  end
  config.vm.provision :hostmanager

end
