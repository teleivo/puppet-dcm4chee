# Private class: See README.md for documentation.
class dcm4chee::params {

  $server = true
  $server_version = '2.18.0'
  $server_host = 'localhost'
  $server_java_path = undef
  $server_java_opts = undef
  $server_http_port = '8080'
  $server_ajp_connector_port = '8009'
  $server_dicom_aet = 'DCM4CHEE'
  $server_dicom_port = '11112'
  $user = 'dcm4chee'
  $user_home = '/opt/dcm4chee/'
  $staging_path = '/opt/dcm4chee/staging/'
  $database = true
  $database_type = 'postgresql'
  $database_host = 'localhost'
  $database_port = undef
  $database_name = 'pacsdb'
  $database_owner_password = 'dcm4chee'
  $dicom_webviewer = true
  $dicom_webviewer_hosts_allow = undef
  
  if !($::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04'
  and $::architecture == 'amd64') {
    fail('Module only supports Ubuntu 14.04 64bit')
  }
}
