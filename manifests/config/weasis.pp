# Class: dcm4chee::config::weasis. See README.md for documentation.
class dcm4chee::config::weasis () {

  $pacs_host = $::dcm4chee::server_host
  $pacs_aet = $::dcm4chee::server_dicom_aet
  $pacs_port = $::dcm4chee::server_dicom_port
  $weasis_hosts_allow = $::dcm4chee::dicom_webviewer_hosts_allow

  $weasis_connector_file = 'weasis-connector.properties'
  $weasis_connector_file_path =
  "${::dcm4chee::dcm4chee_server_conf_path}${weasis_connector_file}"

  file { $weasis_connector_file_path:
    ensure  => file,
    owner   => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    mode    => '0644',
    content => template("dcm4chee/dcm4chee_home/server/default/deploy/${weasis_connector_file}.erb"
    ),
  }
}
