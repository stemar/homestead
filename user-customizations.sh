# Custom bash provisioning commands
sudo timedatectl set-timezone Canada/Pacific
echo "Time zone: " $(cat /etc/timezone)
sudo apt-get -y install tree zip

