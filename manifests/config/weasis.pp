class dcm4chee::config::weasis (
  $aet         = 'DCM4CHEE',
  $host        = 'localhost',
  $port        = '11112',
  $hosts_allow = '',) {
  $weasis_aet = $aet
  $weasis_host = $host
  $weasis_port = $port
  $weasis_hosts_allow = $hosts_allow

  $weasis_connector_file = 'weasis-connector.properties'
  $weasis_connector_file_path =
  "${::dcm4chee::server_conf_path}${weasis_connector_file}"

  file { $weasis_connector_file_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template("dcm4chee/dcm4chee_home/server/default/deploy/${weasis_connector_file}.erb"
    ),
  }
}
