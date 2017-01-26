Ansible RabbitMQ Role
=====================

An ansible role for installing RabbitMQ.

For more information on RabbitMQ, [visit the RabbitMQ website](https://www.rabbitmq.com/)

Role Variables
--------------

```yaml
rabbitmq_ppa_repo: RabbitMQ apt repo 
rabbitmq_ppa_key:  URL of the gpg key
rabbitmq_ppa_key_id: id for the gpg key
rabbitmq_packages: list of packages to install
rabbitmq_service_state: define if the RabbitMQ services needs to be running
rabbitmq_service_enabled: define if the RabbitMQ service needs to be enabled
rabbitmq_default_conf: list of default configuration settings in /etc/default/rabbitmq-server
rabbitmq_env_conf: dict for the rabbitmq_env configuration
rabbitmq_conf: nested list / dict with the rabbitmq configuration. Will be converted to erlang config format
rabbitmq_enable_plugins: list of rabbitmq plugins to enable
rabbitmq_disable_plugins: list of rabbitmq plugins to disable
```

View the default vars - defaults/main.yml - for a more detailed example.

Example Playbook
-------------------------

```yaml
- hosts: servers
  roles:
     - { role: MichaelRigart.rabbitmq, become: true }
```

License
-------

GPLv3

Author Information
------------------

Michaël Rigart <michael@netronix.be>
