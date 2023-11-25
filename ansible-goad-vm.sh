#!/bin/bash
echo "Deploy GOAD v2 on Ubuntu via ansible only - Vagrant was done on the Windows Host and VMWARE which was a pain"

# Ensure we're root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Add repositories
add-apt-repository -y multiverse

# Get list of latest packages
apt-get update

# Make sure we're running on latest versions of things installed
apt-get -y autoupdate

#Install Python PIP
apt-get install git -y
sudo apt install python3-pip -y
pip3 --version


# Download GOAD
cd /opt
git clone https://github.com/aaladha/GOAD goad


# Set up prerequisites
cd /opt/goad/ansible
pip install --upgrade pip
pip install ansible-core==2.12.6
pip install pywinrm

# Install stuff needed for Ansible
ansible-galaxy install -r /opt/goad/ansible/requirements.yml

# Launch provisioning with Ansible
cd /opt/goad/ansible && export ANSIBLE_COMMAND="ansible-playbook -i ../ad/GOAD/data/inventory -i ../ad/GOAD/providers/virtualbox/inventory" && ../scripts/provisionning.sh

# Configure VMs
echo "Run these commands:"
echo "# cd /opt/goad/ansible"
echo "# export ANSIBLE_COMMAND="ansible-playbook -i ../ad/GOAD/data/inventory -i ../ad/GOAD/providers/virtualbox/inventory"
echo "# ansible-playbook -i ../ad/GOAD/data/inventory -i ../ad/GOAD/providers/vmware/inventory main.yml"
echo "OR the export then this command below"
echo "# ../scripts/provisionning.sh"
