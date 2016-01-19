# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  class { 'dcm4chee::config::mysql': } ->
  class { 'dcm4chee::config::jboss': }
  
  if $::dcm4chee::dicom_webviewer {
    class { 'dcm4chee::config::weasis': }
    Class['dcm4chee::config::jboss'] ->
    Class['dcm4chee::config::weasis']
  }
}
