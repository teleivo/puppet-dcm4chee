Exec {
    path => [ "/usr/bin", "/bin", "/usr/sbin", "/sbin" ]
}

class { 'dcm4chee':
    java_path                => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    jboss_http_port          => 8081,
    jboss_ajp_connector_port => 8089,
    jboss_java_opts          => [ '-Xms128m',
                                  '-Xmx740m',
                                  '-XX:MaxPermSize=256m',
                                  '-Dsun.rmi.dgc.client.gcInterval=3600000',
                                  '-Dsun.rmi.dgc.server.gcInterval=3600000',
    ],
}

