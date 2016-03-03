# Class: dcm4chee: See README.md for documentation.
class dcm4chee (
  $server                    = $::dcm4chee::params::server,
  $server_version            = $::dcm4chee::params::server_version,
  $server_host               = $::dcm4chee::params::server_host,
  $server_java_path          = $::dcm4chee::params::server_java_path,
  $server_java_opts          = $::dcm4chee::params::server_java_opts,
  $server_http_port          = $::dcm4chee::params::server_http_port,
  $server_ajp_connector_port = $::dcm4chee::params::server_ajp_connector_port,
  $server_log_file_path      = $::dcm4chee::params::server_log_file_path,
  $server_log_file_max_size  = $::dcm4chee::params::server_log_file_max_size,
  $server_log_append         = $::dcm4chee::params::server_log_append,
  $server_log_max_backups    = $::dcm4chee::params::server_log_max_backups,
  $server_log_appenders      = $::dcm4chee::params::server_log_appenders,
  $server_dicom_aet          = $::dcm4chee::params::server_dicom_aet,
  $server_dicom_port         = $::dcm4chee::params::server_dicom_port,
  $server_dicom_compression  = $::dcm4chee::params::server_dicom_compression,
  $server_service_ensure     = $::dcm4chee::params::server_service_ensure,
  $server_service_enable     = $::dcm4chee::params::server_service_enable,
  $manage_user               = $::dcm4chee::params::manage_user,
  $user                      = $::dcm4chee::params::user,
  $user_home                 = $::dcm4chee::params::user_home,
  $database                  = $::dcm4chee::params::database,
  $database_type             = $::dcm4chee::params::database_type,
  $database_host             = $::dcm4chee::params::database_host,
  $database_port             = $::dcm4chee::params::database_port,
  $database_name             = $::dcm4chee::params::database_name,
  $database_owner_password   = $::dcm4chee::params::database_owner_password,
  $weasis                    = $::dcm4chee::params::weasis,
  $weasis_aet                = $::dcm4chee::params::weasis_aet,
  $weasis_request_addparams  = $::dcm4chee::params::weasis_request_addparams,
  $weasis_request_ids        = $::dcm4chee::params::weasis_request_ids,
  $weasis_hosts_allow        = $::dcm4chee::params::weasis_hosts_allow,
) inherits dcm4chee::params {

  $tcp_port_max = 65535
  $tcp_port_min = 0

  validate_bool($server)
  validate_re($server_version, '(^2.18.1$)', "server_version ${server_version} is not supported. Allowed values are '2.18.1'.")
  validate_string($server_host)
  validate_array($server_java_opts)
  validate_integer($server_http_port, $tcp_port_max, $tcp_port_min)
  validate_integer($server_ajp_connector_port, $tcp_port_max, $tcp_port_min)
  validate_string($server_log_file_path)
  validate_string($server_log_file_max_size)
  validate_bool($server_log_append)
  validate_integer($server_log_max_backups)

  # Only allow appenders which actually exist in jboss-log4j.xml
  validate_array($server_log_appenders)
  if empty($server_log_appenders) {
    fail('server_log_appenders cannot be empty. Choose from values: FILE, CONSOLE, JMX')
  }
  if ! member(['FILE', 'CONSOLE', 'JMX'], $server_log_appenders) {
    fail('server_log_appenders contains invalid members. Choose from values: FILE, CONSOLE, JMX')
  }

  validate_string($server_dicom_aet)
  validate_integer($server_dicom_port, $tcp_port_max, $tcp_port_min)
  validate_bool($manage_user)
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
  
  validate_bool($weasis)
  validate_string($weasis_aet)
  validate_string($weasis_request_addparams)
  
  # Only allow request.ids which are allowed by weasis-pacs-connector
  validate_array($weasis_request_ids)
  if empty($weasis_request_ids) {
    fail('weasis_request_ids cannot be empty. Choose from values: patientID, studyUID, accessionNumber, seriesUID, objectUID')
  }
  if ! member(['patientID', 'studyUID', 'accessionNumber', 'seriesUID', 'objectUID'], $weasis_request_ids) {
    fail('weasis_request_ids contains invalid members. Choose from values: patientID, studyUID, accessionNumber, seriesUID, objectUID')
  }
  validate_array($weasis_hosts_allow)

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

  if $manage_user {
    user { $user:
      ensure     => present,
      home       => $user_home,
      managehome => true,
    }
  }
  
  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'dcm4chee::begin': } ->
  class { '::dcm4chee::staging': } ->
  anchor { 'dcm4chee::end': }
  
  if $database {
    class { '::dcm4chee::database': }
    Anchor['dcm4chee::begin'] ->
    Class['::dcm4chee::database'] ->
    Anchor['dcm4chee::end']

    Class['::dcm4chee::staging'] -> Class['::dcm4chee::database']
  }
  
  if $server {
    class { '::dcm4chee::install': }
    class { '::dcm4chee::config': }
    class { '::dcm4chee::service': }
    Anchor['dcm4chee::begin'] ->
    Class['::dcm4chee::staging'] ->
    Class['::dcm4chee::install'] ->
    Class['::dcm4chee::config'] ~>
    Class['::dcm4chee::service'] ->
    Anchor['dcm4chee::end']

    if $database {
      Class['::dcm4chee::database'] ->
      Class['::dcm4chee::install']
    }
  }
}
