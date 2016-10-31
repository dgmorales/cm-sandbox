node 'cmserver.local' {
  # This is the SSH key we are going to use to authorize access from ansible, rundeck, etc.
  # On the cmserver we will need the private key
  file {'/root/.ssh/master':
    source => 'file:///vagrant/provision/ssh/master',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
  file {'/root/.ssh/master.pub':
    source => 'file:///vagrant/provision/ssh/master.pub',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}

node default {
  include ::role::base
}

node 'saltmaster.local' {
  include ::role::base
  include ::role::saltmaster
}
