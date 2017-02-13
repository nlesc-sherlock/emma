dd if=/dev/zero of=/data/swapfile bs=1024 count=4096k
mkswap /data/swapfile
swapon /data/swapfile
echo "/data/swapfile       none    swap    sw      0       0" >> /etc/fstab
