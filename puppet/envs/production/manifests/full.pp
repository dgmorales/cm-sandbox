node /m[0-9]\..*/ {
  $org_role = 'rabbitmq_cluster1'
  include role::base
  include role::rabbitmq
}

node default {
  include ::role::base
}
