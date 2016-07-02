Ansible Erlang Role
===================
[![Build Status](https://semaphoreci.com/api/v1/projects/eaf7bd15-ef5a-46f4-90e5-95e95777096e/459439/badge.svg)](https://semaphoreci.com/michaelrigart/ansible-role-erlang)

An ansible role for installing Erlang.

For more information on Erlang, [visit the Erlang website](https://www.erlang-solutions.com)

Role Variables
--------------

```yaml
erlang_ppa_repo: erlang apt repo 
erlang_ppa_key: URL of the gpg key
erlang_ppa_key_id: id for the gpg key
erlang_packages: list of packages to install
```

View the default vars - defaults/main.yml - for a more detailed example.

Example Playbook
-------------------------

```yaml
- hosts: servers
  roles:
     - { role: MichaelRigart.erlang, sudo: Yes }
```

License
-------

GPLv3

Author Information
------------------

Michaël Rigart <michael@netronix.be>
