class role::rabbitmq {
  class {'erlang': }
  ->
  class {'::profile::rabbitmq': }
}
