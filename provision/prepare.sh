#!/bin/sh

cd /tmp
# Puppet agent
if ! rpm -q puppet-agent > /dev/null
then
	rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	yum install puppet-agent -y
else
	echo "## Puppet agent already installed ##"
fi
