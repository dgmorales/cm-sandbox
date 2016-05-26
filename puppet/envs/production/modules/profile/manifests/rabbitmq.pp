# RabbitMQ profile class
#
# Our RabbitMQ is configured to ....

class profile::rabbitmq (
  $admin_username = 'admin',
  $admin_password,
  $cluster_hosts = undef,
  $apps = {},
  $other_users = {}, # other extra users besides admin and app related users
  $other_perms = {}, # other extra permissions as well
) {


  if $cluster_hosts {
    # we only configure rabbitmq cluster if cluster_hosts is set
    $config_cluster = true
    $cluster_nodes = keys($cluster_hosts)

    # Set /etc/hosts entries using puppet native host type, to ensure the nodes can always find
    # each other's IP.

    $host_defaults = {
      'ensure' => present,
      'before' => Class['::rabbitmq'],
    }
    create_resources(host, $cluster_hosts, $host_defaults)

  } else {
    $config_cluster = false
    $cluster_nodes = []
  }

  ### Main rabbitmq installation
  # Note that:
  # * The :: prefixing the class name is needed. Otherwise we the name will clash with this
  #   profile::rabbitmq class itself (may be different for newer puppet versions).
  # * Most parameters we set via hiera
  # * Some params we hardcode right here
  # * Some are calculated above
  #
  # The -> between the declarations is a handy way to set dependency without specifying
  # require => Class['rabbitmq']
  class {'::rabbitmq':
    config_cluster           => $config_cluster,
    cluster_nodes            => $cluster_nodes,
    cluster_node_type        => 'disc',
    wipe_db_on_cookie_change => true,           # This is needed so it can set the cookie.
    delete_guest_user        => true,
  }
  ->
  rabbitmq_user { $admin_username:
    admin    => true,
    password => $admin_password,
  }
  ->
  rabbitmq_user_permissions { "${admin_username}@/":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # make sure ::rabbitmq is done when profile::rabbitmq is done.
  contain '::rabbitmq'

  ### Prepare applications (creates vhosts, users, perms, etc for each one)
  create_resources(profile::rabbitmq::app, $apps)

  ### Create extra users (besides admin and the default ones for apps), and permissions.
  create_resources(rabbitmq_user, $other_users)
  create_resources(rabbitmq_user_permissions, $other_perms)

  ###
}
