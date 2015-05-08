Exec {
    path => [ "/usr/bin", "/bin", "/usr/sbin", "/sbin" ]
}

include 'mysql::server'

class { 'dcm4chee':
    java_path                => "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java",
    jboss_http_port          => 8081,
    jboss_ajp_connector_port => 8089,
}

