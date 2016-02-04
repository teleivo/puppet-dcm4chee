# Class: dcm4chee::install: See README.md for documentation.
class dcm4chee::install () {

  file { $::dcm4chee::dcm4chee_home_path:
    source  => $::dcm4chee::staging_dcm4chee_home_path,
    recurse => true,
  }
  
  $jboss_home_path = $::dcm4chee::dcm4chee_home_path
  $java_path = $::dcm4chee::server_java_path
  file { '/etc/init.d/dcm4chee':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('dcm4chee/etc/init.d/dcm4chee.erb'),
  }
}
