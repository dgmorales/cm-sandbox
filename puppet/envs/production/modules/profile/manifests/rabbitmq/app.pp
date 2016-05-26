# all we need for a new rabbitmq application

define profile::rabbitmq::app(
  $user_password,
  $user_name = $title,
  $vhost_name = $title,
) {

  # app specific vhost
  rabbitmq_vhost { $vhost_name:
    ensure => present,
  }
  ->
  # app specific user
  rabbitmq_user { $user_name:
    admin    => false,
    password => $user_password,
  }
  ->
  rabbitmq_user_permissions { "${user_name}@${$vhost_name}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
  ->
  # admin user has full access to all aplications
  rabbitmq_user_permissions {
    "${::profile::rabbitmq::admin_username}@${$vhost_name}":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # ha-policy
  rabbitmq_policy { "ha-2@${vhost_name}":
    pattern    => '.*', # mirror all queues
    priority   => 0,
    definition => {
      'ha-mode'   => 'exactly',
      'ha-params' => '2',
    },
    require    => Rabbitmq_vhost[$vhost_name],
  }
}
