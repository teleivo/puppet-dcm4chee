# Class: dcm4chee::config: See README.md for documentation.
class dcm4chee::config () {
  
  $database_class = "::dcm4chee::config::${dcm4chee::database_type}"
  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'dcm4chee::config::begin': } ->
  class { $database_class: } ->
  class { '::dcm4chee::config::jboss': } ->
  anchor { 'dcm4chee::config::end': }
  
  if $::dcm4chee::weasis {
    class { '::dcm4chee::config::weasis': }
    Anchor['dcm4chee::config::begin'] ->
    Class['::dcm4chee::config::weasis'] ->
    Anchor['dcm4chee::config::end']

    Class['::dcm4chee::config::jboss'] -> Class['::dcm4chee::config::weasis']
  }
}
