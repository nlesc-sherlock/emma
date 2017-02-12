dd if=/dev/zero of=/swapfile bs=1024 count=4096k
mkswap /swapfile
swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab
