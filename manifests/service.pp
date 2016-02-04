# Class: dcm4chee::service: See README.md for documentation.
class dcm4chee::service () {

  service { 'dcm4chee':
    ensure => 'running',
    enable => true,
  }
}
