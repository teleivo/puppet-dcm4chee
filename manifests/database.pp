# Class: dcm4chee::database. See README.md for documentation.
class dcm4chee::database () {

  $database_class = "dcm4chee::database::${dcm4chee::database_type}"
  class { $database_class: }
}
