#!/bin/sh

sudo apt-get install git
sudo apt-get install slurm-llnl
sudo apt-get install python3
sudo apt-get install cmake
sudo apt-get install build-essential cmake libevdev-dev libudev-dev libgl1-mesa-dev libusb-1.0.0-dev libao-dev libpulse-dev libxrandr-dev libopenal-dev libasound2-dev libzmq3-dev libgtk2.0-dev libpng12-dev

# The following snippet is from: https://github.com/p4lang/behavioral-model/blob/master/travis/install-nanomsg.sh
THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $THIS_DIR/common.sh

# nanomsg is very confusing in how it manages SOVERSION vs VERSION, but this
# should be okay... (5.0.0 is the SOVERSION)
check_lib libnanomsg libnanomsg.so.5.0.0

set -e
wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz -O nanomsg-1.0.0.tar.gz
tar -xzvf nanomsg-1.0.0.tar.gz
cd nanomsg-1.0.0
mkdir build
cd build
# I added -DCMAKE_INSTALL_PREFIX=/usr because on my Ubuntu	 14.04 machine, the
# library is installed in /usr/local/lib/x86_64-linux-gnu/ by default, and for
# some reason ldconfig cannot find it
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
# remove sudo if you don't have permissions
sudo cmake --build . --target install
cd ../..

# The following snippet is from: https://github.com/p4lang/behavioral-model/blob/master/travis/install-nnpy.sh
set -e
git clone https://github.com/nanomsg/nnpy.git
# top of tree won't install
cd nnpy
git checkout c7e718a5173447c85182dc45f99e2abcf9cd4065
# remove sudo if you don't have permissions
sudo pip3 install cffi
sudo pip3 install .
cd ..

sudo pip3 install melee
sudo pip3 install numpy
sudo pip3 install argparse
sudo pip3 install iproute2
sudo pip3 install tensorflow
sudo pip3 install netifaces
sudo pip3 install resource

git clone https://github.com/vladfi1/dolphin.git
cd dolphin
mkdir build
cd build
cmake ..
make
cd ../..

git clone https://github.com/vladfi1/phillip.git
sudo pip3 install -e phillip

wget https://bit.ly/2qSKrgV
