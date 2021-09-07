#!/usr/bin/env bash

# This script will setup hostname, install salt and make required salt directories on saltmaster server.
# This script will seamlessly work on Ubuntu 20.04 LTS. It is not tested on other platforms.
# Salt installation is a bootstrap method which identifies the platform and does the installation by itself.
# Some of the content of this script is taken from https://repo.saltproject.io/#bootstrap
# Author: Inderpal Singh
# Date: 3 September, 2021

# Script starts here.

# Set hostname.

sudo hostnamectl set-hostname saltmaster
echo "Hostname set to saltmaster."

# Create directory to hold salt installation files and change directory.

mkdir -p salt_install_files 
cd salt_install_files
echo "Created salt_install_files directory to hold salt installation files."

# Download salt

curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
curl -fsSL https://bootstrap.saltproject.io/sha256 -o install_salt_sha256
echo "Downloaded salt install files."

# Verify file integrity

sha_of_file=$(sha256sum install_salt.sh | cut -d ' ' -f 1)
sha_for_validation=$(cat install_salt_sha256)
if [ "$sha_of_file" == "$sha_for_validation" ]
then
	# Install salt as the SHA256 message digest matches.
	sudo sh install_salt.sh -P -M -x python3
	echo "Salt version: $(salt --version)"
	fi
else
	# If hash check fails, then don't install salt and exit.
	echo "WARNING! this file is corrupt or has been tampered with! Exiting script without installation!!!"
	exit 1
fi

# Create directories for salt

sudo mkdir -p /srv/salt/base
sudo mkdir -p /srv/saltpillar
echo "Directories needed by salt in /srv are created."

# Change back to home directory of user.

cd


