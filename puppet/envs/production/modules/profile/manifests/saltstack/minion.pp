class profile::saltstack::minion {
  include apt
  
  apt::source { 'saltstack':
    location => "http://repo.saltstack.com/apt/ubuntu/${::os.release.full}/amd64/latest",
    key      => "https://repo.saltstack.com/apt/ubuntu/${::os.release.full}/amd64/latest/SALTSTACK-GPG-KEY.pub",
    repos    => "${::os.release.codename} main",
  }

  package {'salt-minion':
    ensure => installed,
  }
}
