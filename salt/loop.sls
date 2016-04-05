{% for binary in ['run', 'build', 'update', 'foo'] %}
/usr/local/bin/myapp-{{ binary }}:
  file.symlink:
    - target: /opt/myapp/bin/{{ binary }}
{% endfor %}
