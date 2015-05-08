class dcm4chee::install (
) {
    file { $dcm4chee::home_path:
        source  => $::dcm4chee::staging_home_path,
        recurse => true,
    }

    mysql::db { $dcm4chee::db_name:
        user     => $dcm4chee::db_owner,
        password => $dcm4chee::db_owner_password,
        host     => $dcm4chee::db_host,
        grant    => ['ALL'],
        sql      => "${dcm4chee::sql_path}/create.mysql",
        require => File["$dcm4chee::home_path"],
    }
}
