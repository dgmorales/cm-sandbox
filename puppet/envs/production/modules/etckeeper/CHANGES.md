etckeeper module for puppet
===========================

0.0.9
-----
Update templates to support puppet 3.0. - @oc243
Add class params for git commit author and email.

0.0.8
-----
Support Amazon Linux AMI.
Use puppetlabs_spec_helper gem.
Add spec tests.

0.0.7
-----
Fixed support for Oracle Linux Server 6. - @sedden

0.0.6
-----
Add support for Oracle Linux Server 6. - @sedden

0.0.5
-----
Fix etckeeper init call for Ubuntu >= 11.10. - @sedden

0.0.4
-----
Create /etc/etckeeper with mode 0755. - @cpick
Support git packages for Ubuntu versions prior to Maverick. - @lorello

0.0.3
-----
[BUG] initialize etckeeper after install.

0.0.2
-----
[BUG] module would break if /etc/etckeeper dir not present.

0.0.1
-----
First release!
