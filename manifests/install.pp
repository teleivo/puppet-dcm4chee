# Class: dcm4chee::install: See README.md for documentation.
class dcm4chee::install () {

  file { $dcm4chee::home_path:
    source  => $dcm4chee::staging_home_path,
    recurse => true,
  }
}
