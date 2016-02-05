# Class: dcm4chee::database. See README.md for documentation.
class dcm4chee::database () {

  anchor { 'dcm4chee::database::begin': } ->
  class { "::dcm4chee::database::${dcm4chee::database_type}": } ->
  anchor { 'dcm4chee::database::end': }
}
