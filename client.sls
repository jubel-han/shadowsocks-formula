{% from 'ss/map.jinja' import config %}

include:
  - ss.init

install-kcptunnel-client-package:
  file.managed:
    - name: /usr/local/bin/kcptun-client
    - source: http://sf.example.com/client_linux_amd64
    - source_hash: md5=fec1f15af761d2c523002ceb75b96b23
    - mode: 755

shadowsocks-client-configuration:
  file.managed:
    - name: /etc/sslocal.json
    - source: salt://ss/files/ss.json
    - template: jinja
    - context:  
      config: {{ config['ss-client'] }}
      password: {{ config['password'] }}

kcptunnel-client-startup:
  file.managed:
    - name: /etc/init/kcptun-client.conf
    - source: salt://ss/files/kcptun-client.conf
    - template: jinja
    - context:
      config: {{ config['kcptun-client'] }}

shadowsocks-client-startup:
  file.managed:
    - name: /etc/init/sslocal.conf
    - source: salt://ss/files/ss.conf
    - template: jinja
    - context:
      type: "sslocal"

start-kcptun-client-service:
  service.running:
    - name: kcptun-client
    - enable: True
    - reload: True

start-sslocal-service:
  service.running:
    - name: sslocal
    - enable: True
    - reload: True
    - watch:
      - service: kcptun-client
