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
4. Passwordless login as root with `${HOST_NAME}.key` private key.
5. XFS Partition mounted at /data/local (used for swapfile, GlusterFS brick, Docker root)
6. Python2 to run Ansible tasks

See Build/Cloud chapter to automate step 4, 5 and 6.

# Ansible

The project uses ansible to provision servers. The recommended version is Ansible 2.2.

##Install ansible
Ansible should be installed using pip. To install pip and ansible dependencies do the following:

```
#Install pip:
sudo apt-get install python-pip

#Install dependencies:
sudo apt install libffi-dev python-dev libssl-dev

#Install ansible (Note that sudo is not used here because you are installing Ansible into your own virtual environment.):
pip install ansible

```

POSIX user `${HOST_NAME}` created with password `pass1234`.
To add more users edit `roles/common/vars/main.yml` file.

Firewall only allows connections from trusted networks.
The trusted networks can be changed in `roles/common/vars/main.yml` file.

Create the `hosts` file see `hosts.template` for template. To change ansible configurations the user should edit ansible.cfg at the root directory of this repository. A diff between it and the file under /etc/ansible/ansible.cfg shows the additions to the default version. 

## Ansible on Windows
When running on a Windows environment it is recommended to use the embedded Ubuntu environment, [installation guide](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide).
Once installed it recommended to verify if the version 16.04 is installed.
```
lsb_release -a
```

If not 16.04, then do the following:
```
#Powershell as administrator, and enter the command
lxrun /uninstall /full .

lxrun /install /y

#Verify again the version:
lsb_release -a
```

After the installation the Ubuntu environment is accessible through the bash command of Windows.
To add Windows executables to your Ubuntu *$PATH*, do the following:
```
export PATH=$PATH:/mnt/c/Windows/System32/
```

Note the *C* drive will be mounted with the files owned by *root* and file permissions set to *777*.
This means ssh keys will to open for Ansible. Hence, before you run ansible you need to call getHosts.sh.

## GlusterFS

See http://gluster.readthedocs.io
All nodes have a xfs partition which is available as `gv0` volume and mounted as /data/shared on all nodes.
The volume is configured (replicas/stripes/transport/etc) in `roles/glusterfs/tasks/create-volume.yml` file.

## Minio

[Minio](https://www.minio.io/) is a distributed object storage server built for cloud applications and devops.
To use minio in distributed mode and have redundancy there are some pre-requisites. To understand them you should read the [distributed minio quickstart guide](https://docs.minio.io/docs/distributed-minio-quickstart-guide).
Before you set a minio cluster, make sure you set minio global variables using the template under *vars/*.
Once initialized a web GUI will be available at *http://${HOST_NAME}0.${HOST_DOMAIN}:9091*, or any other host part of the *minio* group.

For unit tests please read the README under *roles/minio/tests/*.

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

The Docker swarm endpoint is at `<docker_manager_ip>` IP address.
Howto see https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/

To use Swarm login on `docker-swarm-manager` host as configured in `hosts` file.

# Build

## Requirements

Setup environment:
```
#create and edit env_linux.sh
cp env_linux.sh.template env_linux.sh

#Linux environments (also in the embedded Ubuntu environment in Windows).
#On each bash
. env_linux.sh

# Key used by root
ssh-keygen -f ${HOST_NAME}.key
# Key used by ${HOST_NAME} user
ssh-keygen -f roles/common/files/${HOST_NAME}.key
sudo pip install ansible
```

For easy understanding of the examples below it is assumed HOST_NAME=emma

## Vagrant

For vagrant based setup, skip this when deploying to cloud.

###Installation

For Linux systems a simple package installation is enough.
```
#Ubuntu
sudo apt-get install vagrant
```

For Windows, despite the [Ubuntu environment](#windows) was set to run Ansible, vagrant needs to be installed for Windows and be executed using the CMD console. To install it download *msi* file from: https://www.vagrantup.com/downloads.html. Sometimes there are directories ownership issues with vagrant installation. To solve it is required to click in properties and claim ownership of the directory so the installation can proceed.

The path to vagrant home should not have spaces. Assuming the installation path was the default one, set home to *VAGRANT_HOME=C:\HashiCorp\Vagrant\home*:
```
#create and edit env_windows.cmd
cp env_windows.cmd.template env_windows.cmd

#On windows command console run
env_windows.cmd
```

On Windows to run Vagrant's commands use the CMD console.

###Plugins
Vagrant needs two plugins and they will be installed in *VAGRANT\_HOME*.
```
#Plugin for persistent storage
vagrant plugin install vagrant-persistent-storage

#Plugin to manage hosts
vagrant plugin install vagrant-hostmanager

#It is recommended to install vbguest plugin
vagrant plugin install vagrant-vbguest
```

###VMs management

Always make sure the environment for the Windows console is always set, always do:
```
#On windows command console run
env_windows.cmd
```

On Windows because the [Ubuntu environment](#windows) has its own */etc/hosts* the IPs of the guest nodes needs to be retrieved by hand..
At the bash console edit */etc/hosts* with IPs obtained through.
```
vagrant ssh-config %HOST_NAME%0

# With output given by the above command connect to emma0 (only the port will differ)
ssh -i .vagrant/machines/${HOST_NAME}0/virtualbox/private_key ubuntu@127.0.0.1 -p <emma0_port> "cat /etc/hosts"
```

On the first *vagrant up* guest machines */etc/hosts* will be updated. It is possible to request a new update by simply do:
```
vagrant hostmanager
```

To halt all VMs
```
vagrant halt
```

To destroy all VMs
```
vagrant destroy
```

## Cloud

For cloud based setup, skip this when deploying to vagrant.
The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with:
```
ansible-playbook -e datadisk=/dev/vdb prepcloud-playbook.yml
```

If a apt is auto updating the playbook will fail. Use following commands to clean on the host:
```
kill <apt process id>
dpkg --configure -a
```

## Check


Verify login.
```
ssh -i ${HOST_NAME}.key root@${HOST_NAME}0.$HOST_DOMAIN uptime
ssh -i ${HOST_NAME}.key root@${HOST_NAME}1.$HOST_DOMAIN uptime
ssh -i ${HOST_NAME}.key root@${HOST_NAME}2.$HOST_DOMAIN uptime
```

Now use ansible to verify login.
```
ansible all -u root -m ping
```

## Provision

```
ansible-playbook playbook.yml
```

Ansible will ask for a Docker swarm token, which should be printed by the previous task.

### Start demo

```
ansible-playbook demo.yml
```

Afterwards there will be a website available on http://\<docker-swarm-manager\>.
