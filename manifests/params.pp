# Private class: See README.md for documentation.
class dcm4chee::params {

  $server = true
  $server_version = '2.18.0'
  $server_host = 'localhost'
  $server_java_path = undef
  $server_java_opts = undef
  $server_http_port = '8080'
  $server_ajp_connector_port = '8009'
  $user = 'dcm4chee'
  $user_home = '/opt/dcm4chee/'
  $staging_path = '/opt/dcm4chee/staging/'
  $database = true
  $database_host = 'localhost'
  $database_port = '3306'
  $database_name = 'pacsdb'
  $database_owner = 'dcm4chee'
  $database_owner_password = 'dcm4chee'
  
  if !($::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04'
  and $::architecture == 'amd64') {
    fail('Module only supports Ubuntu 14.04 64bit')
  }

  $archive_basename = "dcm4chee-${server_version}-mysql"
  $staging_dcm4chee_home_path = "${staging_path}${archive_basename}/"
  $dcm4chee_home_path = "${user_home}${archive_basename}/"

  $jboss_version = '4.2.3.GA'

  $bin_rel_path = 'bin/'
  $sql_rel_path = 'sql/'
  $server_rel_path = 'server/default/'
  $server_deploy_rel_path = "${server_rel_path}deploy/"
  $server_conf_rel_path = "${server_rel_path}conf/"
}
