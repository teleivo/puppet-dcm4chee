# Class: dcm4chee::service: See README.md for documentation.
class dcm4chee::service (
  $jboss_home_path = undef,
  $java_path = undef
) {

  file { "/etc/init.d/dcm4chee":
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
  }
}
