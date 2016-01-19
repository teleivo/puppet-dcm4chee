# Class: dcm4chee: See README.md for documentation.
class dcm4chee (
  $server                   = $::dcm4chee::params::server,
  $java_path                = $::dcm4chee::params::java_path,
  $user                     = $::dcm4chee::params::user,
  $user_home                = $::dcm4chee::params::user_home,
  $home_path                = $::dcm4chee::params::dcm4chee_home_path,
  $staging_home_path        = $::dcm4chee::params::staging_dcm4chee_home_path,
  $database                 = $::dcm4chee::params::database,
  $database_host            = $::dcm4chee::params::database_host,
  $database_port            = $::dcm4chee::params::database_port,
  $database_name            = $::dcm4chee::params::database_name,
  $database_owner           = $::dcm4chee::params::database_owner,
  $database_owner_password  = $::dcm4chee::params::database_owner_password,
  $jboss_http_port          = $::dcm4chee::params::jboss_http_port,
  $jboss_ajp_connector_port = $::dcm4chee::params::jboss_ajp_connector_port,
  $jboss_java_opts          = $::dcm4chee::params::jboss_java_opts,
) inherits dcm4chee::params {

  $tcp_port_max = 65535
  $tcp_port_min = 0

  validate_bool($server)
  validate_string($user)
  validate_absolute_path($user_home)
  validate_absolute_path($home_path)
  validate_absolute_path($staging_home_path)
  validate_bool($database)
  validate_string($database_host)
  validate_integer($database_port, $tcp_port_max, $tcp_port_min)
  validate_string($database_name)
  validate_string($database_owner)
  validate_string($database_owner_password)

  validate_integer($jboss_http_port, $tcp_port_max, $tcp_port_min)
  validate_integer($jboss_ajp_connector_port, $tcp_port_max, $tcp_port_min)

  if ($server == false and $database == false) {
    fail('server and database cannot both be false')
  }

  if ($server == true and $java_path == undef) {
    fail('java_path is undefined. needs to be defined if server = true')
  }

  $bin_path = "${home_path}${::dcm4chee::params::bin_rel_path}"
  $sql_path = "${staging_home_path}${::dcm4chee::params::sql_rel_path}"
  $server_deploy_path =
  "${home_path}${::dcm4chee::params::server_deploy_rel_path}"
  $server_conf_path = "${home_path}${::dcm4chee::params::server_conf_rel_path}"

  user { $user:
    ensure     => present,
    home       => $user_home,
    managehome => true,
  }->
  
  class { 'dcm4chee::staging': }
  
  if $database {
    class { 'dcm4chee::database': }
    Class['dcm4chee::staging'] ->
    Class['dcm4chee::database']
  }
  
  if $server {
    class { 'dcm4chee::install': }
    class { 'dcm4chee::config': }
    class { 'dcm4chee::service':
      jboss_home_path => $home_path,
      java_path       => $java_path,
    }
    Class['dcm4chee::staging'] ->
    Class['dcm4chee::install'] ->
    Class['dcm4chee::config'] ~>
    Class['dcm4chee::service']

    if $database {
      Class['dcm4chee::database'] ->
      Class['dcm4chee::install']
    }
  }
}
