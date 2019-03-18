Dask
====

Shared [Dask](http://dask.pydata.org) cluster.

The Dask scheduler is run on the `dask-scheduler` host on port 9091.

To use in Python
```python
from dask.distributed import Client
client = Client('<dask-scheduler>:9091')
```

Requirements
------------

* Cluster is running as `ubuntu` posix user, so user should exist.
* The firewall should allow incoming connections to the Dask scheduler port on the scheduler host.

Role Variables
--------------

This role has the following variables:
```yaml
# Port on which dask scheduler is running
dask_scheduler_port: 9091
# Work directory of Dask scheduler
dask_scheduler_dir: "/home/ubuntu/"
# Work directory of Dask worker
dask_worker_dir: "/home/ubuntu/"
```

This role has the following host groups:
* `dask-scheduler`, Host on which Dask scheduler is run
* `dask-worker`, Hosts on which Dask workers are run

Dependencies
------------

No dependencies on other Ansible roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

Apache v2.0

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
