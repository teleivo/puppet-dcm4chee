# Class: dcm4chee::config::jboss. See README.md for documentation.
class dcm4chee::config::jboss () {
  
  $jboss_http_port = $::dcm4chee::server_http_port
  $jboss_ajp_connector_port = $::dcm4chee::server_ajp_connector_port

  $jboss_server_web_deploy_path = "${::dcm4chee::dcm4chee_server_deploy_path}jboss-web.deployer/"
  $jboss_server_xml_path = "${jboss_server_web_deploy_path}server.xml"

  file { $jboss_server_xml_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template('dcm4chee/dcm4chee_home/server/default/deploy/jboss-web.deployer/server.xml.erb'
    ),
  }

  $jboss_java_opts = empty($::dcm4chee::server_java_opts) ? {
    true  => undef,
    false => $::dcm4chee::server_java_opts,
  }
  file { "${::dcm4chee::dcm4chee_bin_path}run.conf":
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template('dcm4chee/dcm4chee_home/bin/run.conf.erb'),
  }

  $jboss_log_file_path = $::dcm4chee::server_log_file_path
  $jboss_log_file_max_size = $::dcm4chee::server_log_file_max_size
  $jboss_log_append = $::dcm4chee::server_log_append
  $jboss_log_max_backups = $::dcm4chee::server_log_max_backups
  $jboss_log_appenders = $::dcm4chee::server_log_appenders
  file { "${::dcm4chee::dcm4chee_server_conf_path}jboss-log4j.xml":
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template('dcm4chee/dcm4chee_home/server/default/conf/jboss-log4j.xml.erb'),
  }
}

