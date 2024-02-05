#/usr/bin/env bash

# From https://medium.com/@nullbyte.in/raspberry-pi-4-ubuntu-20-04-lts-ros2-a-step-by-step-guide-to-installing-the-perfect-setup-57c523f9d790
sudo apt update && sudo apt install locales --no-install-recommends
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# First ensure that the Ubuntu Universe repository is enabled.
sudo apt install software-properties-common curl --no-install-recommends
sudo add-apt-repository universe

# Now add the ROS 2 GPG key with apt.
sudo apt update
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Then add the repository to your sources list.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS2 Packages
sudo apt update && sudo apt -y upgrade

# Install ROS Core and Development Tools
sudo apt install -y ros-foxy-ros-base python3-argcomplete ros-dev-tools python3-pip python3-opencv python3-websocket python3-colcon-common-extensions python3-rosinstall --no-install-recommends

# Update Python
sudo pip3 install -U "setuptools<=65.6.3" pip

# Other dependencies
sudo apt install libuvc0

# Tensorflow and dependencies
sudo pip3 install -U "tensorflow<2.11" "tensorboard<2.11" "numpy<1.20" "cython<3"

# Compile and Install OpenVINO
bash openvino-build.sh
sudo mkdir -p /opt/intel
cd ~/openvino/build/ && sudo make install
sudo ln -sf /opt/intel/openvino_2021.3 /opt/intel/openvino_2021
sudo ln -sf /opt/intel/openvino_2021.3 /opt/intel/openvino

source /opt/intel/openvino/bin/setupvars.sh
bash /opt/intel/openvino/install_dependencies/install_NCS_udev_rules.sh

# Init ROS
sudo rosdep init
sudo rosdep fix-permissions
rosdep update --include-eol-distros

# Install deepracer-scripts
cd ~/
git clone https://github.com/davidfsmith/deepracer-scripts
cd deepracer-scripts
./dev-stack-build.sh

# Get mxcam
cd ~/
git clone https://github.com/doitaljosh/geocam-bin-armhf
