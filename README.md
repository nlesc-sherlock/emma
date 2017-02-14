Ansible playbook to create a cluster with GlusterFS, Docker, Spark and JupyterHub services.

Features:

* Vagrant/Cloud
* Ansible
* GlusterFS
* Docker Swarm
* Spark Standalone cluster
(TODO: * JupyterHub with Spark support (http://toree.apache.org/))

# Features

# Vagrant/Cloud

Install in develop setup with Vagrant.

Use cloud machines to make services available for others.
When using cloud machines they are/have:
* Ubuntu 16.04 OS
* Passwordless login as root with `emma.key` private key.
* OS disk, 200Mb for software + enough room in /tmp
* XFS Partition mounted at /data/local (used for swapfile, GlusterFS brick, Docker root)
* Python2 to run Ansible tasks
* Public network interface

The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with:
```
ansible-playbook --private-key=emma.key -i hosts -e datadisk=/dev/vdb prepcloud-playbook.yml
```

# Ansible

Uses ansible to provision servers.

POSIX user `emma` created with password `pass1234`.
To add more users edit `roles/common/vars/main.yml` file.

Firewall only allows connections from trusted networks.
The trusted networks can be changed in `roles/common/vars/main.yml` file.

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

All nodes have a Docker deamon running.

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

For vagrant based setup, skip this when deploying to cloud:
```
vagrant plugin install vagrant-persistent-storage
vagrant up
```

Create the `hosts` file see `hosts.template` for template.

Setup and verify login
```
ssh -i emma.key root@emma0.$EMMA_DOMAIN uptime
ssh -i emma.key root@emma1.$EMMA_DOMAIN uptime
ssh -i emma.key root@emma2.$EMMA_DOMAIN uptime
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

Afterwards there will be a website available on http://<docker-swarm-manager>.
