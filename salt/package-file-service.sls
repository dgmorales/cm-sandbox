openssh-server:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh
    - enable: True

  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd_config
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: openssh-server
