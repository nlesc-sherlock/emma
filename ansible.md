# Ansible
Ansible is used to setup environment in a set of machines.

## Setup environment:
Every time the user opens a bash console on Windows or Linux the environment is set through the following commands:
```
#Windows
cd <path_to_emma>/emma
. env_linux.sh
./env_windows.sh

#Linux
cd <path_to_emma>/emma
. env_linux.sh
```
The user should check if each role has extra steps to setup environment. For example, the Hadoop role requires the generation of an extra ssh-key for the Hadoop user.

## Install ansible
The recommended version is Ansible 2.2. Ansible should be installed using pip. To install pip and ansible dependencies do the following:
```
# Update apt-get
sudo  apt-get update

#Install pip:
sudo apt-get install python-pip

#Install dependencies:
sudo apt install libffi-dev python-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev 

# For Unit tests, testinfra: https://github.com/philpep/testinfra
sudo pip install testinfra

#Dependencies
pip install wheel

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

Through [ansible-tags](http://docs.ansible.com/ansible/playbooks_tags.html) it is possible to have fine grained control over the task execution. Currently we have the following tags:
* **firewall**: it only updates firewall
* **python_packages**: it only installs extra Python modules using pip
* **system_packages**: it only install extra System packages using apt-get
* **hadoop**: it only installs/starts/stops services related with hadoop role
* **minio**: it only installs/starts/stops services related with minio role
* **spark**: it only installs/starts/stops services related with spark role
* **jupyterhub**: it only installs/starts/stops services related with jupyterhub role
* **jupyter_modules**: it only installs extra modules for jupyterhub

If you wanted to just to update firewall instead of run the entire installation, you could do this:
```
ansible-playbook playbooks/install_spark.yml --tags "firewall"
```
On the other hand, if you want to start the platform with exception of Minio service, you could do this:
```
ansible-playbook start_platform.yml --skip-tags "minio"
```

### Update an existent cluster
In case a cluster is already installed and the user wants update the **Hadoop** or **Spark** cluster to an older or newer version the user should do the following:
```
#edit vars/hadoop_vars.yml and set
hadoop_prev_version: "<current_version>"
hadoop_version: "<new_version>"

#edit vars/spark_vars.yml and set
spark_prev_version: "<current_version>"
spark_version: "<new_version>"

#Run installation script just for Hadoop and Spark
ansible-playbook playbooks/install_spark.yml --tags "hadoop,spark"

#In case the user does not want to format HDFS
ansible-playbook playbooks/install_spark.yml --tags "hadoop,spark" --skip-tags "hdfs_format"
```

## Demo deployment

A demo deployment which uses the platform set by the above playbooks is done using the demos for the Sherlock project.
```
ansible-playbook demo.yml
```
Once deployed, a website is available on http://\<docker-swarm-manager\> (\<docker-swarm-manager\> is defined in the hosts file as described in [ansible.md](ansible.md).
