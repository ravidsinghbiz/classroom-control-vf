class nginx {

  package {"nginx":
    ensure => present,
  }

  File {
    ensure => file,
    owner => 'root',
    group => 'root',
  }

  file { '/var/www':
    ensure => directory,
  }

  file { '/var/www/index.html':
    source => 'puppet:///modules/nginx/index.html',
  }

  file { '/etc/nginx/nginx.conf':
    source => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify => Service['nginx'],
  }

  file { '/etc/nginx/conf.d':
    ensure => directory,
  }

  file { '/etc/nginx/conf.d/default.conf':
    source => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
    enable => true,
  }
}
