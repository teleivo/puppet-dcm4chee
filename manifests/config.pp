# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  class { 'dcm4chee::config::mysql': } ->
  class { 'dcm4chee::config::jboss': } ->
  class { 'dcm4chee::config::weasis': }
}
