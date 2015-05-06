Exec {
    path => [ "/usr/bin", "/bin", "/usr/sbin", "/sbin" ]
}

user { 'dcm4chee':
    ensure      => present,
    home        => '/opt/dcm4chee',
    managehome  => true,
}->

class { 'dcm4chee::staging':
}

