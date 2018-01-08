# Vagrant

Vagrant is a tool to emulate a cluster of machines. Version **2.0.1** is recommended.

## Requirements

The user needs to have [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed. Version **5.2.4** is recommended.

## Installation

For Linux systems a simple package installation is enough.
```
#Ubuntu
wget https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
sudo dpkg -i vagrant_2.0.1_x86_64.deb
```

For Windows, despite the [Ubuntu environment](#windows) was set to run Ansible, vagrant needs to be installed as if it was to be executed using the CMD console. To install it download *msi* file from: https://www.vagrantup.com/downloads.html. Sometimes there are directories ownership issues with vagrant installation. To solve it is required to click in properties and claim ownership of the directory so the installation can proceed. Despite it is installed to be used on the CMD console vagrant.exe can be called from using [Ubuntu environment](#windows). Before doing that some environment variables need to be set. Create *env_linux.sh* and run *env_windows.sh* on [Ubuntu environment](#windows) before using *vagrant.exe*. It is important to make sure home directory for vagrant has write permissions for Windows users, not only for Windows root/administrator.
```
#create and edit env_linux.sh.template
cp env_linux.sh.template env_linux.cmd

#edit it
vim env_linux.cmd

#On Ubuntu bash for Windows run, it is required to restart all consoles to have the environment variables set.
./env_windows.sh
```

**NOTE:** despite the [Ubuntu environment](#windows) is used to run Vagrant the user should call the vagrant's command as this:
```
vagrant.exe
```

### Plugins
Vagrant needs two plugins and they will be installed in *VAGRANT\_HOME*.
```
#Plugin for persistent storage
vagrant(.exe) plugin install vagrant-persistent-storage

#Plugin to manage hosts
vagrant(.exe) plugin install vagrant-hostmanager

#It is recommended to install vbguest plugin
vagrant(.exe) plugin install vagrant-vbguest
```

## VMs management

On Windows to run Vagrant's commands simply use Ubuntu bash console.
To create the virtual machines or start them use:
```
vagrant(.exe) up
```

To update guest machines */etc/hosts* the user after a *vagrant up* should always run:
```
vagrant(.exe) hostmanager
```

On Linux the host machine */etc/hosts* will automatically be updated. On Windows because the [Ubuntu environment](#windows) has its own */etc/hosts* the guest nodes IPs need to be retrieved by hand. After *vagrant hostmanager* run:
```
sh getHosts.sh
```

To halt all VMs
```
vagrant(.exe) halt
```

To destroy all VMs
```
vagrant(.exe) destroy
```

In case vagrant needs to be set using a private network due to issues in getting IPs in the public network the option **--network-type=private_network** should be used.
```
vagrant(.exe) --network-type=private_network up
```

If not used, vagrant will set a public network by default. To switch between a public and private network and vice versa it is required a **vagrant(.exe) halt** and then **vagrant(.exe) up**, it is not recommended to use **vagrant(.exe) reload**.

## Check

Verify login for *N* hosts.
```
ssh -i ${CLUSTER_NAME}.key root@${CLUSTER_NAME}0.$HOST_DOMAIN uptime
...
ssh -i ${CLUSTER_NAME}.key root@${CLUSTER_NAME}N.$HOST_DOMAIN uptime
```
