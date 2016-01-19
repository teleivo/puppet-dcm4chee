# Private class: See README.md for documentation.
class dcm4chee::params {

  $server = true
  $server_host = 'localhost'
  $java_path = undef
  $user = 'dcm4chee'
  $user_home = '/opt/dcm4chee/'
  $staging_path = '/opt/dcm4chee/staging/'
  $database = true
  $database_host = 'localhost'
  $database_port = '3306'
  $database_name = 'pacsdb'
  $database_owner = 'dcm4chee'
  $database_owner_password = 'dcm4chee'
  $jboss_http_port = '8080'
  $jboss_ajp_connector_port = '8009'
  $jboss_java_opts = undef
  
  if !($::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04'
  and $::architecture == 'amd64') {
    fail('Module only supports Ubuntu 14.04 64bit')
  }

  $dcm4chee_version = '2.18.0'
  $archive_basename = "dcm4chee-${dcm4chee_version}-mysql"
  $staging_dcm4chee_home_path = "${staging_path}${archive_basename}/"
  $dcm4chee_home_path = "${user_home}${archive_basename}/"

  $jboss_version = '4.2.3.GA'

  $bin_rel_path = 'bin/'
  $sql_rel_path = 'sql/'
  $server_rel_path = 'server/default/'
  $server_deploy_rel_path = "${server_rel_path}deploy/"
  $server_conf_rel_path = "${server_rel_path}conf/"
}
