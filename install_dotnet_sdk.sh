#!/bin/bash

rm -f /tmp/packages-microsoft-prod.deb
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb

sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove
sudo apt -y install apt-transport-https
sudo apt -y install dotnet-sdk-3.1 dotnet-sdk-2.1
