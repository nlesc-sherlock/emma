# Hadoop
The platform uses Hadoop HDFS as a file system for Spark. For web-ui access to it use [the hadoop-name node address defined in the inventory file](https://github.com/nlesc-sherlock/emma/blob/master/ansible.md#provision) which is listening on port **50070**.

To have password less ssh connections between nodes for the hadoop user, it is necessary to generate a ssh-key with the name **id_rsa**. It should be stored under **files** in the **hadoop** role.
```
cd roles/hadoop/files/
ssh-keygen -t rsa
```
