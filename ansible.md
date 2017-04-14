# Ansible to setup environment in a set of machines
Ansible playbook to create a cluster with HDFS, Spark, SciSpark, and JupyterHub services.

## Setup environment:
```
#create and edit env_linux.sh
cp env_linux.sh.template env_linux.sh
vim env_linux.sh

#Linux environments (also in the embedded Ubuntu environment in Windows).
#On each bash
. env_linux.sh

# Key used by root
ssh-keygen -f ${HOST_NAME}.key
# Key used by ${HOST_NAME} user
ssh-keygen -f roles/common/files/${HOST_NAME}.key
```

## Install ansible
The recommended version is Ansible 2.2. Ansible should be installed using pip. To install pip and ansible dependencies do the following:
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

## Provision

Create the `hosts` file see `hosts.template` for template. To change ansible configurations the user should edit ansible.cfg at the root directory of this repository. A diff between it and the file under /etc/ansible/ansible.cfg shows the additions to the default version. 

Now use ansible to verify login.
```
ansible all -u root -i hosts -m ping
```

For cloud based setup, skip this when deploying to vagrant. The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with:
```
ansible-playbook -e datadisk=/dev/vdb prepcloud-playbook.yml
```

If a apt is auto updating the playbook will fail. Use following commands to clean on the host:
```
kill <apt process id>
dpkg --configure -a
```

Time to setup the cluster.
```
ansible-playbook playbook.yml
```
