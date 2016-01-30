Exec {
  path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin']
}

package { [
  'unzip',
  'curl']:
}

class { 'dcm4chee':
  server_java_path          => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
  server_http_port          => 8081,
  server_ajp_connector_port => 8089,
  require                   => [Package['unzip'], Package['curl']],
}
