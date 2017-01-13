{% from 'ss/map.jinja' import config %}

include:
  - ss.init

install-kcptunnel-server-package:
  file.managed:
    - name: /usr/local/bin/kcptun-server
    - source: http://sf.example.com/server_linux_amd64
    - source_hash: md5=acf96007e4000772f6eebbc969ae3574
    - mode: 755

shadowsocks-server-configuration:
  file.managed:
    - name: /etc/ssserver.json
    - source: salt://ss/files/ss.json
    - template: jinja
    - context:  
      config: {{ config['ss-server'] }}
      password: {{ config['password'] }}

kcptunnel-server-startup:
  file.managed:
    - name: /etc/init/kcptun-server.conf
    - source: salt://ss/files/kcptun-server.conf
    - template: jinja
    - context:
      config: {{ config['kcptun-server'] }}

shadowsocks-server-startup:
  file.managed:
    - name: /etc/init/ssserver.conf
    - source: salt://ss/files/ss.conf
    - template: jinja
    - context:
      type: "ssserver"

start-kcptun-server-service:
  service.running:
    - name: kcptun-server
    - enable: True
    - reload: True

start-ssserver-service:
  service.running:
    - name: ssserver
    - enable: True
    - reload: True
    - watch:
      - service: kcptun-server
