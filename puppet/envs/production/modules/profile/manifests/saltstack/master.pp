class profile::saltstack::master {

  contain profile::saltstack::minion

  package {'salt-master':
    ensure  => installed,
    require => Class['profile::saltstack::minion'],
  }
}
