# Cloud

For cloud based setup, skip this when deploying to vagrant. The disk (in example /dev/vdb) for /data/local can be partitioned/formatted/mounted (also sets ups ssh keys for root) with (make sure first you read [ansible.md](ansible.md) to have ansbile up and running):
```
ansible-playbook -e datadisk=/dev/vdb prepcloud-playbook.yml
```

