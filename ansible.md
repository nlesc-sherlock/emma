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
#create and edit env_linux.sh
cp env_linux.sh.template env_linux.sh

#Linux environments (also in the embedded Ubuntu environment in Windows).
#On each bash
. env_linux.sh

# Key used by root
ssh-keygen -f ${HOST_NAME}.key
# Key used by ${HOST_NAME} user
ssh-keygen -f roles/common/files/${HOST_NAME}.key
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

POSIX user `${HOST_NAME}` created with password `pass1234`.
To add more users edit `roles/common/vars/main.yml` file.

Firewall only allows connections from trusted networks.
The trusted networks can be changed in `roles/common/vars/main.yml` file.

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

## HDFS

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

The Docker swarm endpoint is at `<docker_manager_ip>` IP address (Set in `hosts` file).
Howto see https://docs.docker.com/engine/swarm/swarm-tutorial/deploy-service/

To use Swarm login on `docker-swarm-manager` host as configured in `hosts` file.


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

Create the `hosts` file see `hosts.template` for template. To change ansible configurations the user should edit ansible.cfg at the root directory of this repository. A diff between it and the file under /etc/ansible/ansible.cfg shows the additions to the default version. 

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

## Provision

```
ansible-playbook playbook.yml
```

Ansible will ask for a Docker swarm token, which should be printed by the previous task.

