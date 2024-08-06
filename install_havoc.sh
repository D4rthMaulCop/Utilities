#!/usr/bin/zsh

# install dependencies
apt update -y
apt install -y git
apt install -y build-essential
apt install -y apt-utils
apt install -y cmake
apt install -y libfontconfig1
apt install -y libglu1-mesa-dev
apt install -y libgtest-dev
apt install -y libspdlog-dev
apt install -y libboost-all-dev
apt install -y libncurses5-dev
apt install -y libgdbm-dev
apt install -y libssl-dev
apt install -y libreadline-dev
apt install -y libffi-dev
apt install -y libsqlite3-dev
apt install -y libbz2-dev
apt install -y mesa-common-dev
apt install -y qtbase5-dev
apt install -y qtchooser
apt install -y qt5-qmake
apt install -y qtbase5-dev-tools
apt install -y libqt5websockets5
apt install -y libqt5websockets5-dev
apt install -y qtdeclarative5-dev
apt install -y golang-go
apt install -y qtbase5-dev
apt install -y libqt5websockets5-dev
apt install -y python3-dev
apt install -y libboost-all-dev
apt install -y mingw-w64
apt install -y nasm
sleep 120

# build Havoc
git clone https://github.com/HavocFramework/Havoc.git
git checkout dev
cd Havoc
cd teamserver
go mod download golang.org/x/sys
sleep 10
go mod download github.com/ugorji/go
sleep 10
cd ..
make ts-build
sleep 120
make client-build