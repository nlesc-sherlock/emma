#Minio

To mount a local dir to a bucket in minio you need to mirror in two directions with option -w to watch for changes. The mirror should run in background.
```
#All these commands should be run in all hosts.

#register a alias in ~/.mc/config for a S3 storage service
mc config host add s3 <host_ip>:9091 <acess_key> <secret_key> S3v4
example: mc config host add s3 http://145.100.116.245:9091 A24H1RIGV4RKFGXJTEMS 5jd7ARCOi/XVjLzXqT5wA1NSgjmUo9mYJBgyGyIh S3v4

#Lets get what is in the S3 my bucket into /data/shared/
mc mirror -w /data/shared s3/mybucket &

#Lets get what is in the S3 my bucket into /data/shared/
mc mirror -w s3/mybucket /data/shared/ &

To mirror sub-directories you need to mirror them with a different bucket. 
For example, to mirror /data/shared/scratch

mc mirror -w /data/shared/scratch s3/superbucket &
mc mirror -w s3/superbucket /data/shared/scratch/ &
```
