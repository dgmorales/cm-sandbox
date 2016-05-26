package { 'openssh-server':
  ensure => installed,
}

file { '/etc/ssh/sshd_config':
  source  => 'file:///vagrant/puppet/sshd_config',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['ssh']
#  require => Package['openssh-server'],
 }

service { 'ssh':
  ensure => running,
  enable => true,
}
