class dcm4chee::config::mysql (
  $db_name,
  $db_owner,
  $db_owner_password,
  $db_host = 'localhost',
  $db_port = 3306,) {
  $db_connection_file = 'pacs-mysql-ds.xml'
  $db_connection_file_path =
  "${::dcm4chee::server_deploy_path}${db_connection_file}"

  file { $db_connection_file_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template("dcm4chee/dcm4chee_home/server/default/deploy/${db_connection_file}.erb"
    ),
  }
}
