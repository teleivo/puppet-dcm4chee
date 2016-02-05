# Class: dcm4chee::service: See README.md for documentation.
class dcm4chee::service () {

  $jboss_home_path = $::dcm4chee::dcm4chee_home_path
  $java_path = $::dcm4chee::server_java_path

  file { '/etc/init.d/dcm4chee':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('dcm4chee/etc/init.d/dcm4chee.erb'),
    notify  => Service['dcm4chee'],
  }

  service { 'dcm4chee':
    ensure     => 'running',
    enable     => true,
    provider   => 'init',
    hasrestart => true,
  }
}
