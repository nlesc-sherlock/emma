# Vagrant to emulate a cluster of machines

## Installation

For Linux systems a simple package installation is enough.
```
#Ubuntu
sudo apt-get install vagrant
```

For Windows, despite the [Ubuntu environment](#windows) was set to run Ansible, vagrant needs to be installed as if it was to be executed using the CMD console. To install it download *msi* file from: https://www.vagrantup.com/downloads.html. Sometimes there are directories ownership issues with vagrant installation. To solve it is required to click in properties and claim ownership of the directory so the installation can proceed. Despite it is installed to be used on the CMD console vagrant.exe can be called from using [Ubuntu environment](#windows). Before doing that some environment variables need to be set. Create *env_windows.cmd* and run it on [Ubuntu environment](#windows) before using *vagrant.exe*.

Note: The path to vagrant home should not have spaces. Assuming the installation path was the default one, vagrant home should also be set to *VAGRANT_HOME=C:\HashiCorp\Vagrant\home*:
```
#create and edit env_windows.cmd
cp env_windows.cmd.template env_windows.cmd

#On Ubuntu bash for Windows run, it is required to restart all consoles to have the environment variables set.
./env_windows.cmd
```
### Plugins
Vagrant needs two plugins and they will be installed in *VAGRANT\_HOME*.
```
#Plugin for persistent storage
vagrant plugin install vagrant-persistent-storage

#Plugin to manage hosts
vagrant plugin install vagrant-hostmanager

#It is recommended to install vbguest plugin
vagrant plugin install vagrant-vbguest
```

## VMs management

On Windows to run Vagrant's commands simply use Ubuntu bash console.
```
vagrant.exe <up | hostmanager | halt | destroy>
```

To update guest machines */etc/hosts* the user after a *vagrant up* should always run:
```
vagrant hostmanager
```

On Linux the host machine */etc/hosts* will automatically be updated. On Windows because the [Ubuntu environment](#windows) has its own */etc/hosts* the guest nodes IPs need to be retrieved by hand. After *vagrant hostmanager* run:
```
sh getHosts.sh
```

To halt all VMs
```
vagrant halt
```

To destroy all VMs
```
vagrant destroy
```

## Check

Verify login for *N* hosts.
```
ssh -i pheno.key root@pheno0.$PHENO_DOMAIN uptime
...
ssh -i pheno.key root@phenoN.$PHENO_DOMAIN uptime
```

