# Class: dcm4chee::database::postgresql. See README.md for documentation.
class dcm4chee::database::postgresql () {

  include '::postgresql::server'

  # Create role, database and give role grants on database 
  ::postgresql::server::db { $::dcm4chee::database_name:
    owner    => $::dcm4chee::user,
    user     => $::dcm4chee::user,
    password => postgresql_password($::dcm4chee::user, $::dcm4chee::database_owner_password),
    grant    => 'ALL',
    require  => Staging::Deploy[$::dcm4chee::staging::dcm4chee_archive_name],
  }
  
  # Allow local ident access to user
  # this rule is used to execute the database creation script
  ::postgresql::server::pg_hba_rule { "${::dcm4chee::user}_ident":
    description => 'allow local ident access for dcm4chee',
    database    => $::dcm4chee::database_name,
    user        => $::dcm4chee::user,
    type        => 'local',
    auth_method => 'ident',
  }

  # Allow host md5 access to user from pacs server
  # this rule is used by the pacs itself
  # compute the pg_hba address value:
  # ip addresses need a mask,
  # localhost or domain names do not
  $pg_hba_host_address = is_ip_address($::dcm4chee::server_host) ? {
    true    => "${::dcm4chee::server_host}/32",
    default => $::dcm4chee::server_host,
  }
  ::postgresql::server::pg_hba_rule { "${::dcm4chee::user}_host":
    description => 'allow host md5 access for dcm4chee',
    database    => $::dcm4chee::database_name,
    user        => $::dcm4chee::user,
    type        => 'host',
    address     => $pg_hba_host_address,
    auth_method => 'md5',
  }

  # Validate that created role can connect to the database
  # Note: this needs pg_hba role ident
  $validate_name = "${::dcm4chee::database_name}-connection"
  ::postgresql::validate_db_connection { $validate_name:
    database_name => $::dcm4chee::database_name,
    database_port => $::dcm4chee::database_port_picked,
    run_as        => $::dcm4chee::user,
    require       => Postgresql::Server::Db[$::dcm4chee::database_name],
  }

  $validate_dcm4chee_database_created =
  '/usr/local/bin/validate_dcm4chee_database_created.sh'
  file { $validate_dcm4chee_database_created:
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source =>
    'puppet:///modules/dcm4chee/validate_dcm4chee_database_created.sh',
  }
  
  # Create tables in database from sql script
  $cmd_init = '/usr/bin/psql --quiet --tuples-only'
  $cmd_port = "-p ${::dcm4chee::database_port_picked}"
  $cmd_dbname = "--dbname ${::dcm4chee::database_name}"
  
  $cmd_file = '-f create.psql'
  $create_cmd = join([$cmd_init, $cmd_port, $cmd_dbname, $cmd_file ], ' ')

  $check_table = 'ae'
  $unless_cmd = join([$validate_dcm4chee_database_created, $::dcm4chee::database_name, $check_table, $::dcm4chee::database_port_picked ], ' ')

  # Note: this needs pg_hba role ident
  exec { "create database ${::dcm4chee::database_name} for ${::dcm4chee::user}":
    unless    => $unless_cmd,
    command   => $create_cmd,
    cwd       => $::dcm4chee::dcm4chee_sql_path,
    user      => $::dcm4chee::user,
    logoutput => 'on_failure',
    path      => '/bin:/usr/bin:/usr/local/bin',
    require   => [
      Class['postgresql::client'],
      Postgresql::Server::Db[$::dcm4chee::database_name],
      Postgresql::Validate_db_connection[$validate_name],
      File[$validate_dcm4chee_database_created],
    ],
  }
}
