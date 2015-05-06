class dcm4chee (
    $java_path,
    $user = $::dcm4chee::params::user,
    $home_path = $::dcm4chee::params::dcm4chee_home_path,
    $staging_home_path = $::dcm4chee::params::staging_dcm4chee_home_path,
    $execute_staging = $::dcm4chee::params::execute_staging,
    $db_name = $::dcm4chee::params::db_name,
    $db_owner = $::dcm4chee::params::db_owner,
    $db_owner_password = $::dcm4chee::params::db_owner_password,
    $jboss_http_port = $::dcm4chee::params::jboss_http_port,
    $jboss_ajp_connector_port = $::dcm4chee::params::jboss_ajp_connector_port,
    $jboss_java_opts = $::dcm4chee::params::jboss_java_opts,
) inherits dcm4chee::params {
    $bin_path = "${home_path}${::dcm4chee::params::bin_rel_path}"
    $sql_path = "${home_path}${::dcm4chee::params::sql_rel_path}"
    $server_deploy_path = "${home_path}${::dcm4chee::params::server_deploy_rel_path}"
    $server_conf_path = "${home_path}${::dcm4chee::params::server_conf_rel_path}"

    user { $user:
        ensure      => present,
        home        => $user_home,
        managehome  => true,
    }

    if str2bool(downcase("$execute_staging")) {
        class { 'dcm4chee::staging':
            before  => Class['Dcm4chee::install'], 
            require => User["$user"],
        }
    }

    class { 'dcm4chee::install':
        require => User["$user"],
    }

    class { 'dcm4chee::config':
        require => Class['Dcm4chee::install'],
    }

    class { 'dcm4chee::service':
        require => Class['Dcm4chee::config'],
    }
}
