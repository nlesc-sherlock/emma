# Emma

Emma is a project to create a platform for development of application for Spark and DockerSwarm clusters. The platform runs on an infra-structure composed by virtual machines and Ansible playbooks are used to create a storage layer, processing layer and [JupyterHub](https://jupyter-notebook.readthedocs.io/en/latest/index.html) services. The storage layer offers two flavors of storage, file-base by [GlusterFS](https://www.gluster.org/) and [Hadoop Distributed File System (HDFS)](http://hadoop.apache.org/), and object-based using [Minio](https://www.minio.io). The processing layer has a [Apache Spark cluster](http://spark.apache.org/) and a [Docker Swarm](https://docs.docker.com/engine/swarm/) sharing the storage instances.

## Infra-structure

The infra-structure, physical place where the platform runs, is composed by a set of virtual machines with the following characteristics:
1. Ubuntu 16.04 OS
2. Public network interface
3. OS disk, 200Mb for software + enough room in /tmp
4. Passwordless login as root with `${HOST_NAME}.key` private key.
5. XFS Partition mounted at /data/local (used for swapfile, GlusterFS brick, Docker root)
6. Python2 to run Ansible tasks


The infrastructure is a collection of machines which must be reachable by ssh. The machines must be prepared/constructed by either [preparing cloud virtual machine](cloud.md) or [constructing using Vagrant boxes](vagrant.md)

### Windows environment
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

## Infra-structure provision

Servers are provisioned using [Ansible](https://www.ansible.com/), an automation tool for IT infra-structure. To install it and configure it please read [ansible.md](ansible.md).

The roles defined for Ansbile will create a platform with the following features:

* [GlusterFS](gluster.md)
* [Minio](minio.md)
* [Hadoop](hadoop.md)
* [Spark](spark.md) Standalone cluster
* [Docker Swarm](dockerswarm.md)
* [JupyterHub](jupyterhub.md)

## Deployment

A deployment is done using the demos for the Sherlock project.
```
ansible-playbook demo.yml
```
Once deployed, a website is available on http://\<docker-swarm-manager\> (\<docker-swarm-manager\> is defined in the hosts file as described in [ansible.md](ansible.md).
