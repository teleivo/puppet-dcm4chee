Exec {
  path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin']
}

package { [
  'unzip',
  'curl']:
}

class { 'dcm4chee':
  server_java_path  => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
  server_java_opts  => [
    '-Xms128m',
    '-Xmx740m',
    '-XX:MaxPermSize=256m',
    '-Dsun.rmi.dgc.client.gcInterval=3600000',
    '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
  require           => [Package['unzip'], Package['curl']],
}
