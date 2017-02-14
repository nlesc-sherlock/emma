dd if=/dev/zero of=/data/local/swapfile bs=1024 count=4096k
mkswap /data/local/swapfile
swapon /data/local/swapfile
echo "/data/local/swapfile       none    swap    sw      0       0" >> /etc/fstab
