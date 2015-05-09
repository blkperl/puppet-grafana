# grafana

## Usage

### Install grafana

```puppet
include grafana
```

### Install grafana with a nginx reverse proxy

```puppet
include grafana::nginx
```

### Configure Grafana

```puppet

  Grafana_config {
    notify  => Service['grafana-server'],
  }

 grafana_config {
    'server/domain':              value   => $::fqdn;
    'server/root_url':            value   => "https://${::fqdn}/";
    'users/allow_sign_up':        value   => false;
    'users/auto_assign_org':      value   => true;
    'users/auto_assign_org_role': value   => 'Editor';
  }
```
