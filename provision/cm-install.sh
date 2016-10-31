#!/bin/sh

# TODO: move this to puppet ::profile::base or something like that
cd /tmp
# Puppet agent
if ! dpkg -l puppet-agent > /dev/null
then
	wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
	sudo dpkg -i puppetlabs-release-pc1-trusty.deb
	sudo apt-get update -y
	sudo apt-get install puppet-agent -y
else
	echo "## Puppet agent already installed ##"
fi

## Salt minion
#if ! dpkg -l salt-minion > /dev/null
#then
#	curl -L https://bootstrap.saltstack.com -o install_salt.sh
#	sudo sh install_salt.sh
#else
#	echo
#	echo "## Salt minion already installed ##"
#	echo
#fi


## Ansible (so we can run it locally also)
#if ! dpkg -l ansible > /dev/null
#then
#	sudo apt-get install software-properties-common -y
#	sudo apt-add-repository ppa:ansible/ansible -y
#	sudo apt-get update -y
#	sudo apt-get install ansible -y
#	# there are probably around 2^10 better ways to do this, but anyway ...
#fi
