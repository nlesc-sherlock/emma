# Cloud

Once the virtual machines are instantiated in the cloud give some time for their kernel get updated. To re-use the same inventory file update the **/etc/hosts** with the respective IPs for each host.

For cloud based setup, skip this when deploying to vagrant. The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with (make sure first you read [ansible.md](ansible.md) to have ansbile up and running):
```
ansible-playbook -e datadisk=/dev/vdb prepcloud-playbook.yml
```

If the first run fails because the **apt-get update** fails the solution is to reboot the machines and then log in into each of them using the web-ui and do the following:
```
sudo dpkg --configure -a

#A graphical window will prompt and the first option should be selected, i.e., install the version from the package manager.
```
