# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  class { 'dcm4chee::config::mysql':
    db_name           => $::dcm4chee::db_name,
    db_owner          => $::dcm4chee::db_owner,
    db_owner_password => $::dcm4chee::db_owner_password,
  } ->
  class { 'dcm4chee::config::jboss':
    jboss_http_port          => $::dcm4chee::jboss_http_port,
    jboss_ajp_connector_port => $::dcm4chee::jboss_ajp_connector_port,
    jboss_java_opts          => $::dcm4chee::jboss_java_opts,
  } ->
  class { 'dcm4chee::config::weasis': }
}
