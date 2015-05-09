# Nginx proxies grafana running on localhost
class grafana::nginx {
  include ::nginx

  # grafana vhost
  ::nginx::resource::vhost { $::fqdn:
    add_header           => {
      'Strict-Transport-Security' => '"max-age=63072000; includeSubDomains"',
    },
    ssl                  => true,
    ssl_cert             => '/var/lib/grafana/certs/cert.pem',
    ssl_key              => '/var/lib/grafana/certs/key.pem',
    ssl_port             => 443,
    use_default_location => false,
  }

  ::nginx::resource::upstream { 'grafana_localhost':
    members => [
      'localhost:3000',
    ],
  }

  # Proxy localhost:3000
  ::nginx::resource::location { '/':
    ensure                     => present,
    ssl                        => true,
    ssl_only                   => true,
    vhost                      => $::fqdn,
    proxy                      => 'http://grafana_localhost',
    location_custom_cfg_append => {
      'proxy_next_upstream' =>
        'error timeout invalid_header http_500 http_502 http_503 http_504;',
      'proxy_redirect'      => 'off;',
      'proxy_buffering'     => 'off;',
      'proxy_set_header'    => {
        'Host'              => '$host;',
        'X-Real-IP'         => '$remote_addr;',
        'X-Forwarded-For'   => '$proxy_add_x_forwarded_for;',
        'X-Forwarded-Proto' => 'https;',
      }
    },
  }

  # Redirect http to https
  ::nginx::resource::location { '/-nossl':
    ensure              => present,
    location            => '/',
    location_custom_cfg => {
      'return' => '301 https://$host$request_uri'
    },
    vhost               => $::fqdn,
  }
}
