#Minio

To mount a local dir to a bucket in minio you need to mirror in two directions with option -w to watch for changes. The mirror should run in background.
```
#All these commands should be run in all hosts.

#register a alias in ~/.mc/config for a S3 storage service
mc config host add s3 <host_ip>:9091 <access_key> <secret_key> S3v4
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

Configuration file for s3cmd .s3cfg
```
host_base = 145.100.116.153:9091
host_bucket = 145.100.116.153:9091
access_key = A24H1RIGV4RKFGXJTEMS
secret_key = 5jd7ARCOi/XVjLzXqT5wA1NSgjmUo9mYJBgyGyIh
use_https = False
list_md5 = False
use_mime_magic = False
#Make sure the region is the same as the one used by minio
bucket_location = us-east-1

```

Example of commands:
```
s3cmd  ls s3://files

s3cmd get s3://files/sonnets.txt romulo.txt
```

To upload data to a sub-directory follow this example:
```
cd <root_dir>/<sub_dir> ; for f in `ls *`; do s3cmd put $f s3://<root_dir>/<sub_dir>/$f; done
```
