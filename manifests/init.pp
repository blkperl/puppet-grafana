# Installs grafana server
class grafana {
  include apt

  apt::source { 'grafana':
    key      => {
      'id'   => '418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB',
      source => 'https://packagecloud.io/gpg.key',
    },
    location => 'https://packagecloud.io/grafana/stable/debian',
    release  => 'wheezy',
    repos    => 'main',
  }

  package { 'grafana':
    ensure  => installed,
    require => [
      Apt::Source['grafana'],
    ]
  }

  service { 'grafana-server':
    ensure  => 'running',
    enable  => true,
    require => Package['grafana'],
  }

}
