# Cloud

Once the virtual machines are instantiated in the cloud give some time for their kernel get updated. For cloud based setup, skip this when deploying to vagrant. The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with (make sure first you read [ansible.md](ansible.md) to have Ansbile up and running):
```
#First define the environment, use env_linux.sh.template. Then run
. env_linux.sh

ansible-playbook -e datadisk=/dev/vdb -e host_name=$HOST_NAME prepcloud-playbook.yml
```

If the first run fails because the **apt-get update** fails the solution is to reboot the machines and then log in into each of them using the web-ui and do the following:
```
sudo dpkg --configure -a

#A graphical window will prompt and the first option should be selected, i.e., install the version from the package manager.
```

On [SURFsara HPC cloud each guest node gets an DNS entry](https://doc.hpccloud.surfsara.nl/access-your-VM) as ${vmname}.${projectname}.surf-hosted.nl. They can be used to access web-uis of installed systems such as JupyterHub.
