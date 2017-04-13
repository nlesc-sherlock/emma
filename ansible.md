# Ansible to setup environment in a set of machines
Ansible playbook to create a cluster with HDFS, Spark, SciSpark, and JupyterHub services.

## Features:
* HDFS
* Spark Standalone cluster
* SciSpark
* JupyterHub with Spark support (http://toree.apache.org)

## Requirements

Use cloud machines to make services available for others.
When using cloud machines or vagrant machines they are/have:
1. Ubuntu 16.04 OS
2. Public network interface
3. OS disk, 200Mb for software + enough room in /tmp
4. Passwordless login as root with `pheno.key` private key.
5. XFS Partition mounted at /data/local (used for swapfile)
6. Python2 to run Ansible tasks

Setup environment:
```
#Linux environments (also in the embedded Ubuntu environment in Windows).
export PHENO_DOMAIN=<domain to use>
# Key used by root
ssh-keygen -f pheno.key
# Key used by pheno user
ssh-keygen -f roles/common/files/pheno.key
sudo pip install ansible
```

## Install ansible
The project uses ansible to provision servers. The recommended version is Ansible 2.2.
Ansible should be installed using pip. To install pip and ansible dependencies do the following:

```
#Install pip:
sudo apt-get install python-pip

#Install dependencies:
sudo apt install libffi-dev python-dev libssl-dev

#Install ansible (Note that sudo is not used here because you are installing Ansible into your own virtual environment.):
pip install ansible

```

POSIX user `pheno` created with password `pass1234`.
To add more users edit `roles/common/vars/main.yml` file.

Firewall only allows connections from trusted networks.
The trusted networks can be changed in `roles/common/vars/main.yml` file.

## Ansible on Windows
When running on a Windows environment it is recommended to use the embedded Ubuntu environment, [installation guide](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide).
After the installation the Ubuntu environment is accessible through the bash command of Windows.

Note the *C* drive will be mounted with the files owned by *root* and file permissions set to *777*. Ansible does run with such file permissions. Hence, you need to clone the repository into the home directory of the embedded Ubuntu environment. The environment set on Windows CMD console session, for example to run Vagrant, is not shared with embedded Ubuntu bash.

## HDFS

## Spark
Spark is installed in `/data/shared/spark` directory as Spark Standalone mode.
* For master use `spark://<spark-master>:7077`
* The UI on http://<spark-master>:8080
* The JupyterHub on http://<spark-master>:8000

To get shell of Spark cluster run:
```
spark-shell --master spark://<spark-master>:7077
```

## Provision

Create the `hosts` file see `hosts.template` for template.

Now use ansible to verify login.
```
ansible all --private-key=../pheno.key -u root -i hosts -m ping
```

For cloud based setup, skip this when deploying to vagrant. The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with:
```
ansible-playbook --private-key=../pheno.key --ssh-extra-args="-o StrictHostKeyChecking=no" -i hosts -e datadisk=/dev/vdb prepcloud-playbook.yml
```

If a apt is auto updating the playbook will fail. Use following commands to clean on the host:
```
kill <apt process id>
dpkg --configure -a
```

Time to setup the cluster.
```
ansible-playbook --private-key=../pheno.key --ssh-extra-args="-o StrictHostKeyChecking=no" -i hosts playbook.yml
```
