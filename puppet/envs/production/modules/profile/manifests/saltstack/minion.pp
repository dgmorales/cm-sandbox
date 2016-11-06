class profile::saltstack::minion {

  # as told in https://repo.saltstack.com/#rhel

  package {'salt-repo':
    ensure   => 'present',
    provider => 'rpm',
    source   => 'https://repo.saltstack.com/yum/redhat/salt-repo-latest-1.el7.noarch.rpm',
    notify   => Exec['/bin/yum clean expire-cache'],
  }

  exec {'/bin/yum clean expire-cache':
    refreshonly => true,
  }

  package {'salt-minion':
    ensure  => installed,
    require => Package['salt-repo'],
  }
}
