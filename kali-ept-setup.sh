#!/usr/bin/zsh

# misc
mkdir /root/Tools
touch ~/.hushlogin

# update repo
apt update

# installing additional tools
apt install -y seclists
apt install -y git
apt install -y dirb
apt install -y gobuster
apt install -y golang
apt install -y python3-pip
apt install -y python3-venv
apt install -y wordlists
apt install -y spiderfoot
apt install -y dnsenum
apt install -y dnsrecon
apt install -y net-tools
apt install -y whatweb
apt install -y wpscan
apt install -y nikto
apt install -y theharvester
apt install -y amass
apt install -y nmap

# create engagement data folders
mkdir /root/Client-Data
mkdir /root/Client-Data/Scan\ Data
mkdir /root/Client-Data/Exploits
mkdir /root/Client-Data/Loot
mkdir /root/Client-Data/Scope

# installing tools from github
#pip install git+https://github.com/blacklanternsecurity/trevorproxy
#pip install git+https://github.com/blacklanternsecurity/trevorspray
git clone https://github.com/0xZDH/o365spray.git /root/Tools/o365spray
git clone https://github.com/knavesec/CredMaster.git /root/Tools/CredMaster
git clone https://github.com/D4rthMaulCop/GoMapEnum.git /root/Tools/GoMapEnum

# dotfile installs
wget https://raw.githubusercontent.com/D4rthMaulCop/dotfiles/refs/heads/main/.zshrc -O /root/.zshrc
wget https://raw.githubusercontent.com/D4rthMaulCop/dotfiles/refs/heads/main/.vimrc -O /root/.vimrc

timedatectl set-timezone America/Chicago

source /root/.zshrc