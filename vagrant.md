# Vagrant to emulate a cluster of machines

## Installation

For Linux systems a simple package installation is enough.
```
#Ubuntu
sudo apt-get install vagrant
```

For Windows, despite the [Ubuntu environment](#windows) was set to run Ansible, vagrant needs to be installed for Windows and be executed using the CMD console. To install it download *msi* file from: https://www.vagrantup.com/downloads.html. Sometimes there are directories ownership issues with vagrant installation. To solve it is required to click in properties and claim ownership of the directory so the installation can proceed.

The path to vagrant home should not have spaces. Assuming the installation path was the default one, to set it do the following (create dir before setting it):
```
set VAGRANT_HOME=C:\HashiCorp\Vagrant\home
#set also the PHENO_DOMAIN
set PHENO_DOMAIN=<domain to use>
```

On Windows to run Vagrant's commands use the CMD console.

## Plugins
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

On Windows make sure VAGRANT_HOME is alwasy set.
```
set VAGRANT_HOME=C:\HashiCorp\Vagrant\home
```

Since host-manager is used to update */etc/hosts* on each guest node and host node, the Vagrantfile should be updated.

When running on Linux, and if a DNS server is not used, it is required to tell vagrant to update the host's */etc/hosts* to contain all guest's IPs. In Vagrantfile do the following update:
```
-  config.hostmanager.manage_host = false
+  config.hostmanager.manage_host = true
```
On Windows such option does not have effect because the [Ubuntu environment](#windows) has its own */etc/hosts*.
At the bash console edit */etc/hosts* with IPs obtains through.
```
vagrant ssh-config pheno0

# With output given by the above command connect to pheno0 (only the port will differ)
ssh -i .vagrant/machines/pheno0/virtualbox/private_key ubuntu@127.0.0.1 -p <pheno0_port> "cat /etc/hosts"
```


To update the guest nodes */etc/hosts*, create and start the VMs, read the steps described in [#14](../../issues/14#issuecomment-285029919).

To halt all VMs
```
vagrant halt
```

To destroy all VMs
```
vagrant destroy
```

## Check

Verify login.
```
ssh -i pheno.key root@pheno0.$PHENO_DOMAIN uptime
ssh -i pheno.key root@pheno1.$PHENO_DOMAIN uptime
ssh -i pheno.key root@pheno2.$PHENO_DOMAIN uptime
```
