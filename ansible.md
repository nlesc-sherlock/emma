# Ansible
Ansible is used to setup environment in a set of machines.

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
ssh-keygen -f files/${HOST_NAME}.key
```

The user should check if each role has extra steps to setup environment. For example, the hadoop role requires the generation of an extra ssh-key for the hadoop user.

## Install ansible
The recommended version is Ansible 2.2. Ansible should be installed using pip. To install pip and ansible dependencies do the following:
```
#Install pip:
sudo apt-get install python-pip

sudo apt-get install python-pip 

#Install dependencies:
sudo apt install libffi-dev python-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev 

# For Unit tests, testinfra: https://github.com/philpep/testinfra
sudo pip install testinfra

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

The roles defined for Ansible will create a platform with the following features:

* [GlusterFS](gluster.md)
* [Minio](minio.md)
* [Spark](spark.md) Standalone cluster
* [Docker Swarm](dockerswarm.md)
* [JupyterHub](jupyterhub.md)

Each role will deploy the respective service or system on the node's group specified in **playbook.yml**. Each node's group is defined in the inventory file **hosts**. The **playbook.yml** defines on which order the roles are executed. 

The global variables for each role are defined under *vars/* in a file with the same name as the role. Their values should be set before running any playbook. All templates contain the default values for each role's variable. Note: each variable defined as global will over-write the ones defined under each role in the **defaults/** dir. Hence, to change or extend the a variable definition use the global variable definition.

Once all variables are defined the platform is installed with the following command:
```
ansible-playbook install_platform.yml
```

The platform only needs to be installed once. Once it is installed the services, e.g., Hadoop and Spark, are started using the following command:
```
ansible-playbook start_platform.yml
```

To shutdown the platform just run the following command:
```
ansible-playbook shutdown_platform.yml
```
