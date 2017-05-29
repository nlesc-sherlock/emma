dd if=/dev/zero of=/data/local/swapfile bs=1024 count=1228k
chmod 600 /data/local/swapfile
mkswap /data/local/swapfile
swapon /data/local/swapfile
sh -c 'echo "/data/local/swapfile       none    swap    sw      0       0" >> /etc/fstab'
