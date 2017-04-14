# GlusterFS

See http://gluster.readthedocs.io
All nodes have a xfs partition which is available as `gv0` volume and mounted as /data/shared on all nodes.
The volume is configured (replicas/stripes/transport/etc) in `roles/glusterfs/tasks/create-volume.yml` file.

