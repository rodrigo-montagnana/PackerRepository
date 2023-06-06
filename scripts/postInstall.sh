mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
mv /tmp/authorized_keys /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys

yum update -y
interfaceName=$(nmcli connection show | grep -vi NAME | grep -v "\-\-" | awk '{print $1}' | head -n 1)
nmcli connection modify ${interfaceName} ipv6.method disabled
mkdir /tmp/tmp
mount -o ro /dev/sr1 /tmp/tmp
/tmp/tmp/VBoxLinuxAdditions.run --nox11