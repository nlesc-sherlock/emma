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

## Install Ansible
The recommended version is Ansible 2.3. However, we try to have the playbooks aligned with the latest version.

Ansible should then be install using Ubuntu package manager **apt-get**. To install the latest Ansible the user should follow the [installation instructions from the Ansible web-site](http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu).

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
ansible-playbook install_platform.yml --tags "firewall"
```
On the other hand, if you want to start the platform with exception of Minio service, you could do this:
```
ansible-playbook start_platform.yml --skip-tags "minio"
```

### Update an existent platform
In case a cluster is already installed and the user wants update the **Hadoop** or **Spark** cluster to an older or newer version the user should do the following:
```
#edit vars/hadoop_vars.yml and set
hadoop_prev_version: "<current_version>"
hadoop_version: "<new_version>"

#edit vars/spark_vars.yml and set
spark_prev_version: "<current_version>"
spark_version: "<new_version>"

#Run installation script just for Hadoop and Spark
ansible-playbook install_platform.yml --tags "hadoop,spark"

#In case the user does not want to format HDFS
ansible-playbook install_platform.yml --tags "hadoop,spark" --skip-tags "hdfs_format"
```

### Add new modules
For a new application an user might need to install a new module, such as a python module, using either **pip* or **apt-get**. The library to be installed needs to be listed in **emma/vars/common_vars.yaml** either under the *python_packages* or *system_packages* variables. To install them the user only needs to run an Emma's Ansible playbook:
```
#Pip
ansible-playbook install_platform_light.yml --tags "extra_python_packages"

#Apt-get
ansible-playbook install_platform_light.yml --tags "extra_system_packages"
```

It is also possible to copy *user defined modules (UDM)* such as a **python library**, a **R library** and a **scala jar** to the cluster. To achieve that the user needs to copy the module to the respective folder **emma/files/<python | scala | r>** and call:
```
ansible-playbook install_platform_light.yml --tags "user_defined_modules"
```

The *UDM* is then available at the path **{{ jupyterhub_modules_dir }}/< python | scala | r>**, the default path is */data/local/*.

## Demo deployment

A demo deployment which uses the platform set by the above playbooks is done using the demos for the Sherlock project.
```
ansible-playbook demo.yml
```
Once deployed, a website is available on http://\<docker-swarm-manager\> (\<docker-swarm-manager\> is defined in the hosts file as described in [ansible.md](ansible.md).
