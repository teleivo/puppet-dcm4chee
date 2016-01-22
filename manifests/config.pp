# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  
  $database_class = "::dcm4chee::config::${dcm4chee::database_type}"
  class { $database_class: } ->
  class { '::dcm4chee::config::jboss': }
  
  if $::dcm4chee::dicom_webviewer {
    class { '::dcm4chee::config::weasis': }
    Class['::dcm4chee::config::jboss'] ->
    Class['::dcm4chee::config::weasis']
  }
}
