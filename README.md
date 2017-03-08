Ansible playbook to create a cluster with GlusterFS, Docker, Spark and JupyterHub services.

Features:

* Vagrant/Cloud
* Ansible
* GlusterFS
* Docker Swarm
* Spark Standalone cluster
* JupyterHub with Spark support (http://toree.apache.org)

# Features

# Vagrant/Cloud

Install in develop setup with Vagrant.

Use cloud machines to make services available for others.
When using cloud machines they are/have:
1. Ubuntu 16.04 OS
2. Public network interface
3. OS disk, 200Mb for software + enough room in /tmp
4. Passwordless login as root with `emma.key` private key.
5. XFS Partition mounted at /data/local (used for swapfile, GlusterFS brick, Docker root)
6. Python2 to run Ansible tasks

See Build/Cloud chapter to automate step 4, 5 and 6.

# Ansible

Uses ansible to provision servers.

POSIX user `emma` created with password `pass1234`.
To add more users edit `roles/common/vars/main.yml` file.

Firewall only allows connections from trusted networks.
The trusted networks can be changed in `roles/common/vars/main.yml` file.

## Windows
When running on a Windows environment it is recommended to use the embedded Ubuntu environment, [installation guide](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide).
After the installation the Ubuntu environment is accessible through the bash command of Windows.

Note the *C* drive will be mounted with the files owned by *root* and file permissions set to *777*. Ansible does run with such file permissions. Hence, you need to clone the repository
into the home directory of the embedded Ubuntu environment.

## GlusterFS

See http://gluster.readthedocs.io
All nodes have a xfs partition which is available as `gv0` volume and mounted as /data/shared on all nodes.
The volume is configured (replicas/stripes/transport/etc) in `roles/glusterfs/tasks/create-volume.yml` file.

## Spark

Spark is installed in `/data/shared/spark` directory as Spark Standalone mode.
* For master use `spark://<spark-master>:7077`
* The UI on http://<spark-master>:8080
* The JupyterHub on http://<spark-master>:8000

To get shell of Spark cluster run:
```
spark-shell --master spark://<spark-master>:7077
```

## Docker swarm

All nodes have a Docker daemon running.

The Docker swarm endpoint is at `<docker_manager_ip>` IP address (Set in `hosts` file).
Howto see https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/

To use Swarm login on `docker-swarm-manager` host as configured in `hosts` file.

# Build

## Requirements

Setup environment:
```
export EMMA_DOMAIN=<domain to use>
# Key used by root
ssh-keygen -f emma.key
# Key used by emma user
ssh-keygen -f roles/common/files/emma.key
sudo pip install ansible
```

## Vagrant

For vagrant based setup, skip this when deploying to cloud.

###Installation

For Linux systems a simple package installation is enough.
```
#Ubuntu
sudo apt-get install vagrant
```

For Windows, despite the [Ubuntu environment](tree/vagrant-windows#Windows) was set to run Ansible, vagrant needs to be installed for Windows and be executed using the CMD console.
To install it download *msi* file from: https://www.vagrantup.com/downloads.html. Sometimes there are directories ownership issues with vagrant installation.
To solve it is required to click in properties and claim ownership of the directory so the installation can proceed.

The path to vagrant home should not have spaces.
Assuming the installation path was the default one, to set it do the following (create dir before setting it):
```
set VAGRANT_HOME=C:\HashiCorp\Vagrant\home
```
On Windows run Vagrant's commands on the CMD console.

###Plugins
Vagrant needs two plugins and they will installed in *VAGRANT\_HOME*.
```
#Plugin for persistent storage
vagrant plugin install vagrant-persistent-storage

#Plugin to manage hosts
vagrant plugin install vagrant-hostmanager
```

###VMs management
Initialize, halt and destroy VMs created by vagrant.
```
#Make sure you always have the VAGRANT_HOME set. Following the example above:
set VAGRANT_HOME=C:\HashiCorp\Vagrant\home

#Initialized all VMs, for a specific VM just add the name, for example emma1
vagrant up

#Halt all VMs, for a specific VM just add the name, for example emma1
vagrant halt

#Destroy all VMs, for a specific VM just add the name, for example emma1
vagrant destroy
```

## Cloud

For cloud based setup, skip this when deploying to vagrant.
The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with:
```
ansible-playbook --private-key=emma.key -i hosts -e datadisk=/dev/vdb prepcloud-playbook.yml
```

If a apt is auto updating the playbook will fail. Use following commands to clean on the host:
```
kill <apt process id>
dpkg --configure -a
```

## Check

Obtain hosts IPs. Such information is useful to then update */etc/hosts* on the [Ubuntu environment](tree/vagrant-windows) when running on Windows.
```
vagrant ssh 'cat /etc/hosts'
```

Verify login.
```
ssh -i emma.key root@emma0.$EMMA_DOMAIN uptime
ssh -i emma.key root@emma1.$EMMA_DOMAIN uptime
ssh -i emma.key root@emma2.$EMMA_DOMAIN uptime
```

Create the `hosts` file see `hosts.template` for template.
Now use ansible to verify login.
```
ansible all --private-key=emma.key -u root -i hosts -m ping
```

## Provision

```
ansible-playbook --private-key=emma.key -i hosts playbook.yml
```

Ansible will ask for a Docker swarm token, which should be printed by the previous task.

### Start demo

```
ansible-playbook --private-key=emma.key -i hosts demo.yml
```

Afterwards there will be a website available on http://\<docker-swarm-manager\>.
