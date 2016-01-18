class dcm4chee::config::mysql (
  $database_name,
  $database_owner,
  $database_owner_password,
  $database_host = 'localhost',
  $database_port = 3306,
) {

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
