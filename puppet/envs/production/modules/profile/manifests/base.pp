class profile::base {

  # Having etckeeper is always nice.
  # Then we can make any changes using puppet or manually and check how /etc files were
  # affected.
  #contain '::etckeeper'

  # This is the SSH key we are going to use to authorize access from ansible, rundeck, etc.
  # We want it authorized in all servers.
  #ssh_authorized_key { 'root@cmserver':
  #  user => 'root',
  #  type => 'ssh-rsa',
  #  key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC+HZEXmAD4bzlpRQkBtzQrzHXLkAyWEeH+zCf3wy7eij0lyLRLYpeSmnW2vk79P0bqlv8QpvGpFAVlrC4TdfKgJIzb1T7K/PA0bUucMh3454uts5swmrsngAuXCQwkZFGFp/0p6wX1aOAsnwcL6XdzPI6lPJnbwAN+6DauXHO4WJ4jqZ4eN27xpnBzB7TmNTkXN/k8sGP8//TegCZGhUqRbGsF1jUtkWFujlYvr85kVX15WpmJFNgR9GUFCy09eRau0WXMthJeQt/sJEB+U82jnqrU8rhVcxiTyNrO6MlRUhENC4iq2WoWhHSl6F742FHBU+dMFHQSXkCXppI9Yas/',
  #}

  # Some packages that may be useful for tests/troubleshooting/etc.
  $base_packages = [
    'telnet',
    'screen',
    'tcpdump',
    'nmap',
  ]
  package {$base_packages:
    ensure  => installed,
  }

  # This is to remove the real hostname from the 127.0.0.1 /etc/hosts entry.
  # We don't want that with RabbitMQ.
  file_line {'localhost':
    path  => '/etc/hosts',
    line  => '127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain',
    match => '^127\.0\.0\.1.*',
  }
  file_line {'localhost_1':
    ensure            => absent,
    path              => '/etc/hosts',
    line              => '127.0.1.1 somehostname',
    match             => '^127\.0\.1\.1.*',
    match_for_absence => true,
  }
}
