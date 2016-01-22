# Class: dcm4chee::config::jboss. See README.md for documentation.
class dcm4chee::config::jboss () {
  
  $jboss_java_opts = empty($::dcm4chee::server_java_opts) ? {
    true  => undef,
    false => join($::dcm4chee::server_java_opts, ' '),
  }
  $jboss_http_port = $::dcm4chee::server_http_port
  $jboss_ajp_connector_port = $::dcm4chee::server_ajp_connector_port

  $jboss_server_web_deploy_path = "${::dcm4chee::dcm4chee_server_deploy_path}jboss-web.deployer/"
  $jboss_server_xml_path = "${jboss_server_web_deploy_path}server.xml"
  $jboss_run_conf_path = "${::dcm4chee::dcm4chee_bin_path}run.conf"

  file { $jboss_server_xml_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template('dcm4chee/dcm4chee_home/server/default/deploy/jboss-web.deployer/server.xml.erb'
    ),
  }

  file { $jboss_run_conf_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template('dcm4chee/dcm4chee_home/bin/run.conf.erb'),
  }
}
