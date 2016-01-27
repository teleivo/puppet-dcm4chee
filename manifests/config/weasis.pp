# Class: dcm4chee::config::weasis. See README.md for documentation.
class dcm4chee::config::weasis () {

  $pacs_host = $::dcm4chee::server_host
  $pacs_aet = $::dcm4chee::server_dicom_aet
  $pacs_port = $::dcm4chee::server_dicom_port
  $weasis_request_addparams = $::dcm4chee::weasis_request_addparams
  $weasis_request_ids = join($::dcm4chee::weasis_request_ids, ',')
  $weasis_hosts_allow = join($::dcm4chee::weasis_hosts_allow, ',')
  $weasis_aet = $::dcm4chee::weasis_aet

  $weasis_connector_file = 'weasis-pacs-connector.properties'
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
