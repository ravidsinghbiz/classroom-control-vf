class nginx (
  $package = $nginx::params::package,
  $owner = $nginx::params::owner,
  $group = $nginx::params::group,
  $docroot = $nginx::params::docroot,
  $confdir = $nginx::params::confdir,
  $logdir = $nginx::params::logdir,
  $user = $nginx::params::user,
) inherits nginx::params {
  File {
    ensure => file,
    owner => $owner,
    group => $group,
  }

  package {$package:
    ensure => present,
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/index.html":
    source => 'puppet:///modules/nginx/index.html',
  }

  file { "${confdir}/nginx.conf":
#    source => 'puppet:///modules/nginx/nginx.conf',
    content => template('nginx/nginx.conf.erb'),
    require => Package[$package],
    notify => Service['nginx'],
  }

  file { "${confdir}/conf.d":
    ensure => directory,
  }

  file { "${confdir}/conf.d/default.conf":
#    source => 'puppet:///modules/nginx/default.conf',
    content => template('nginx/default.conf.erb'),
    require => Package[$package],
    notify => Service['nginx'],
  }

  service { 'nginx':
    ensure => running,
    enable => true,
  }
}
