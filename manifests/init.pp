# Class: dcm4chee: See README.md for documentation.
class dcm4chee (
  $java_path,
  $user                     = $::dcm4chee::params::user,
  $user_home                = $::dcm4chee::params::user_home,
  $home_path                = $::dcm4chee::params::dcm4chee_home_path,
  $staging_home_path        = $::dcm4chee::params::staging_dcm4chee_home_path,
  $db_host                  = $::dcm4chee::params::db_host,
  $db_name                  = $::dcm4chee::params::db_name,
  $db_owner                 = $::dcm4chee::params::db_owner,
  $db_owner_password        = $::dcm4chee::params::db_owner_password,
  $jboss_http_port          = $::dcm4chee::params::jboss_http_port,
  $jboss_ajp_connector_port = $::dcm4chee::params::jboss_ajp_connector_port,
  $jboss_java_opts          = $::dcm4chee::params::jboss_java_opts,) inherits
  dcm4chee::params {
  validate_absolute_path($user_home)
  validate_absolute_path($home_path)
  validate_absolute_path($staging_home_path)
  validate_string($db_host)
  validate_string($db_name)
  validate_string($db_owner)
  validate_string($db_owner_password)

  $tcp_port_max = 65535
  $tcp_port_min = 0
  validate_integer($jboss_http_port, $tcp_port_max, $tcp_port_min)
  validate_integer($jboss_ajp_connector_port, $tcp_port_max, $tcp_port_min)

  $bin_path = "${home_path}${::dcm4chee::params::bin_rel_path}"
  $sql_path = "${home_path}${::dcm4chee::params::sql_rel_path}"
  $server_deploy_path =
  "${home_path}${::dcm4chee::params::server_deploy_rel_path}"
  $server_conf_path = "${home_path}${::dcm4chee::params::server_conf_rel_path}"

  user { $user:
    ensure     => present,
    home       => $user_home,
    managehome => true,
  }

  class { 'dcm4chee::staging':
    require => User[$user],
  }

  class { 'dcm4chee::install':
    require => Class['Dcm4chee::staging'],
  }

  class { 'dcm4chee::config':
    require => Class['Dcm4chee::install'],
    notify  => Class['Dcm4chee::service'],
  }

  class { 'dcm4chee::service':
    jboss_home_path => $home_path,
    java_path       => $java_path,
  }
}
