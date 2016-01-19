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
}
