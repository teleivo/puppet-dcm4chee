# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  
  $database_class = "::dcm4chee::config::${dcm4chee::database_type}"

  anchor { '::dcm4chee::config_begin': } ->
  class { $database_class: } ->
  class { '::dcm4chee::config::jboss': } ->
  anchor { '::dcm4chee::config_end': }
  
  if $::dcm4chee::weasis {
    class { '::dcm4chee::config::weasis': }
    Class['::dcm4chee::config::jboss'] ->
    Class['::dcm4chee::config::weasis'] ->
    Anchor['::dcm4chee::config_end']
  }
}
