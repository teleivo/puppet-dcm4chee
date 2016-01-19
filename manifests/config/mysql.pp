class dcm4chee::config::mysql () {
  $database_name = $::dcm4chee::database_name
  $database_owner = $::dcm4chee::database_owner
  $database_owner_password = $::dcm4chee::database_owner_password
  $database_host = $::dcm4chee::database_host
  $database_port = 3306

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
