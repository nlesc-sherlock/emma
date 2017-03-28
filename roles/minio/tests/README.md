For unit tests we will use [testinfra](https://github.com/philpep/testinfra).

To install dependencies and testinfra do the following: 
```
sudo apt-get install python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev
sudo pip install testinfra
```

It is necessary to define ssh-config.
```
#On windows you need to replace the windows path by the Ubuntu environment path.
vagrant ssh-config > ./roles/minio/tests/ssh-config
```

To run a test to verify if minio is installed and up and running run the following:
```
testinfra --ansible-inventory=hosts --ssh-config=./roles/minio/tests/ssh-config --connection=ssh --sudo ./roles/minio/tests/test_minio.py
```
