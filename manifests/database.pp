# Class: dcm4chee::database. See README.md for documentation.
class dcm4chee::database () {

  ::mysql::db { $::dcm4chee::database_name:
    user     => $::dcm4chee::database_owner,
    password => $::dcm4chee::database_owner_password,
    host     => $::dcm4chee::database_host,
    grant    => ['ALL'],
    sql      => "${::dcm4chee::sql_path}/create.mysql",
    require  => Staging::Deploy[$::dcm4chee::staging::dcm4chee_archive_name],
  }
}
