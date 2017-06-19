# Hadoop
The platform uses Hadoop HDFS as a file system for Spark. For web-ui access to it use [the hadoop-name node address defined in the inventory file](https://github.com/nlesc-sherlock/emma/blob/master/ansible.md#provision) which is listening on port **50070**.

For setting up Hadoop on a cluster of machines, the master should be able to do a password-less ssh to start the daemons on all the slaves. Hence, the user should generate a ssh-key with the name **hadoop_id_rsa** and the key should be stored under the directory **files** located at the root directory.
```
cd files/
ssh-keygen -t rsa -f hadoop_id_rsa
```
