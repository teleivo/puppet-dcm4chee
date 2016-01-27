# Class: dcm4chee: See README.md for documentation.
class dcm4chee (
  $server                       = $::dcm4chee::params::server,
  $server_version               = $::dcm4chee::params::server_version,
  $server_host                  = $::dcm4chee::params::server_host,
  $server_java_path             = $::dcm4chee::params::server_java_path,
  $server_java_opts             = $::dcm4chee::params::server_java_opts,
  $server_http_port             = $::dcm4chee::params::server_http_port,
  $server_ajp_connector_port    = $::dcm4chee::params::server_ajp_connector_port,
  $server_dicom_aet             = $::dcm4chee::params::server_dicom_aet,
  $server_dicom_port            = $::dcm4chee::params::server_dicom_port,
  $user                         = $::dcm4chee::params::user,
  $user_home                    = $::dcm4chee::params::user_home,
  $database                     = $::dcm4chee::params::database,
  $database_type                = $::dcm4chee::params::database_type,
  $database_host                = $::dcm4chee::params::database_host,
  $database_port                = $::dcm4chee::params::database_port,
  $database_name                = $::dcm4chee::params::database_name,
  $database_owner_password      = $::dcm4chee::params::database_owner_password,
  $weasis_webviewer             = $::dcm4chee::params::weasis_webviewer,
  $weasis_webviewer_aet         = $::dcm4chee::params::weasis_webviewer_aet,
  $weasis_webviewer_request_ids = $::dcm4chee::params::weasis_webviewer_request_ids,
  $weasis_webviewer_hosts_allow = $::dcm4chee::params::weasis_webviewer_hosts_allow,
) inherits dcm4chee::params {

  $tcp_port_max = 65535
  $tcp_port_min = 0

  validate_bool($server)
  validate_re($server_version, '(^2.18.1$)', "server_version ${server_version} is not supported. Allowed values are '2.18.1'.")
  validate_string($server_host)
  validate_array($server_java_opts)
  validate_integer($server_http_port, $tcp_port_max, $tcp_port_min)
  validate_integer($server_ajp_connector_port, $tcp_port_max, $tcp_port_min)
  validate_string($server_dicom_aet)
  validate_integer($server_dicom_port, $tcp_port_max, $tcp_port_min)
  validate_string($user)
  validate_absolute_path($user_home)
  validate_bool($database)
  validate_re($database_type, '(^mysql|postgresql$)', "database_type ${database_type} is not supported. Allowed values are 'mysql', 'postgresql'.")
  validate_string($database_host)

  $database_port_picked = pick(
    $database_port,
    $database_type ? {
      'mysql' => '3306',
      'postgresql' => '5432',
    }
  )
  validate_integer($database_port_picked, $tcp_port_max, $tcp_port_min)
  validate_string($database_name)
  validate_string($database_owner_password)
  
  validate_bool($weasis_webviewer)
  validate_string($weasis_webviewer_aet)
  validate_array($weasis_webviewer_request_ids)
  if empty($weasis_webviewer_request_ids) {
    fail('weasis_webviewer_request_ids cannot be empty. Choose from values: patientID, studyUID, accessionNumber, seriesUID, objectUID')
  }
  validate_array($weasis_webviewer_hosts_allow)

  if ($server == false and $database == false) {
    fail('server and database cannot both be false')
  }

  if $server == true {
    validate_absolute_path($server_java_path)
  }

  # Define archive name, jboss version and important relative paths
  $database_type_short = $database_type ? {
    'postgresql' => 'psql',
    'mysql'      => 'mysql',
  }
  $dcm4chee_archive_basename = "dcm4chee-${server_version}-${database_type_short}"
  $jboss_version = '4.2.3.GA'
  $dcm4chee_bin_rel_path = 'bin/'
  $dcm4chee_sql_rel_path = 'sql/'
  $dcm4chee_server_rel_path = 'server/default/'
  $dcm4chee_server_deploy_rel_path = "${dcm4chee_server_rel_path}deploy/"
  $dcm4chee_server_conf_rel_path = "${dcm4chee_server_rel_path}conf/"

  # Dicom webviewer versions, settings
  $weasis_version = '2.0.5'
  $weasis_pacs_connector_version = '5.0.1'

  # Construct main paths needed by staging, installation, configuration
  $staging_path = "${user_home}staging/"
  $staging_dcm4chee_home_path = "${staging_path}${dcm4chee_archive_basename}/"

  $dcm4chee_home_path = "${user_home}${dcm4chee_archive_basename}/"
  $dcm4chee_bin_path = "${dcm4chee_home_path}${dcm4chee_bin_rel_path}"
  $dcm4chee_sql_path = "${staging_dcm4chee_home_path}${dcm4chee_sql_rel_path}"
  $dcm4chee_server_deploy_path = "${dcm4chee_home_path}${dcm4chee_server_deploy_rel_path}"
  $dcm4chee_server_conf_path = "${dcm4chee_home_path}${dcm4chee_server_conf_rel_path}"

  user { $user:
    ensure     => present,
    home       => $user_home,
    managehome => true,
  }->
  
  class { '::dcm4chee::staging': }
  
  if $database {
    class { '::dcm4chee::database': }
    Class['::dcm4chee::staging'] ->
    Class['::dcm4chee::database']
  }
  
  if $server {
    class { '::dcm4chee::install': }
    class { '::dcm4chee::config': }
    class { '::dcm4chee::service': }
    Class['::dcm4chee::staging'] ->
    Class['::dcm4chee::install'] ->
    Class['::dcm4chee::config'] ~>
    Class['::dcm4chee::service']

    if $database {
      Class['::dcm4chee::database'] ->
      Class['::dcm4chee::install']
    }
  }
}
