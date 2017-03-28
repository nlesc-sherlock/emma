# -*- mode: ruby -*-
# vi: set ft=ruby :
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

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "public_network", bridge: "enp2s0"
  #Check if there is a new update for the box
  config.vm.box_check_update = true
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

  num_hosts = Integer("#{ENV['NUM_HOSTS']}")-1
  puts "Number of hosts is %s" % num_hosts
  (0..num_hosts).each do |i|
    config.vm.define "#{ENV['HOST_NAME']}#{i}" do |node|
      node.vm.hostname = "#{ENV['HOST_NAME']}#{i}.#{ENV['HOST_DOMAIN']}"
      # GlusterFS storage disk
      node.persistent_storage.enabled = true
      node.persistent_storage.location = "#{ENV['HOST_NAME']}#{i}-data.vdi"
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

  if Vagrant::VERSION =~ /1.9.[0-9]/ && vbox_version =~ /5.1.[0-9]/
    puts "Copy ssh keys by hand."
    config.vm.provision "file", source: "./#{ENV['HOST_NAME']}.key", destination: "/tmp/#{ENV['HOST_NAME']}.key"
    config.vm.provision "file", source: "./#{ENV['HOST_NAME']}.key.pub", destination: "/tmp/#{ENV['HOST_NAME']}.key.pub"
    config.vm.provision "shell", inline: <<-SHELL
      mkdir -p /vagrant
      cp /tmp/#{ENV['HOST_NAME']}.key /vagrant/
      cp /tmp/#{ENV['HOST_NAME']}.key.pub /vagrant/
    SHELL
  end

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /root/.ssh
    cp /vagrant/#{ENV['HOST_NAME']}.key /root/.ssh/id_rsa
    cp /vagrant/#{ENV['HOST_NAME']}.key.pub /root/.ssh/id_rsa.pub
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    chmod -R 600 /root/.ssh
    apt-get update
    apt-get install -y python-dev
  SHELL

  #Hostmanager should be set to false so it runs after provisioning
  config.hostmanager.enabled = false
  config.hostmanager.manage_guest = true
  if OS.windows?
    config.hostmanager.manage_host = false
  else
    config.hostmanager.manage_host = true
  end
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
