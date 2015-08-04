# Class: dcm4chee::service: See README.md for documentation.
class dcm4chee::service (
  $jboss_home_path = undef,
  $java_path = undef
) {
  $initd_script_name = 'pacs-dcm4chee'

  file { "/etc/init.d/${initd_script_name}":
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('dcm4chee/etc/init.d/pacs-dcm4chee.erb'),
    notify  => Service[$initd_script_name],
  }

  service { $initd_script_name:
    ensure => 'running',
    enable => true,
  }
}
