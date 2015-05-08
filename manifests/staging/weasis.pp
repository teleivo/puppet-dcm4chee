class dcm4chee::staging::weasis (
    $weasis_version = '2.0.3',
    $weasis_pacs_connector_version = '5.0.0',
) {
    $weasis_base_url = 'http://sourceforge.net/projects/dcm4che/files/Weasis/'

    $weasis_archive_name = 'weasis.war'
    $weasis_source_url = "${weasis_base_url}${weasis_version}/${weasis_archive_name}"

    $weasis_connector_base_url = "${weasis_base_url}weasis-pacs-connector/${weasis_pacs_connector_version}/"
    $weasis_connector_archive_name = 'weasis-pacs-connector.war'
    $weasis_connector_source_url = "${weasis_connector_base_url}${weasis_connector_archive_name}"
    $weasis_dcm4chee_web_name = 'dcm4chee-web-weasis.jar'
    $weasis_dcm4chee_web_source_url = "${weasis_connector_base_url}${weasis_dcm4chee_web_name}"

    $source_directory = "${dcm4chee::staging_path}weasis/"

    file { $source_directory:
        ensure => directory,
        owner        => $dcm4chee::user,
        group        => $dcm4chee::user,
    }

    staging::file { "${weasis_archive_name}":
        source  => $weasis_source_url,
        target  => "${source_directory}${weasis_archive_name}",
        require => File["${source_directory}"],
    }

    file { "${::dcm4chee::staging::dcm4chee_deploy_path}${weasis_archive_name}":
        ensure       => present,
        owner        => $dcm4chee::user,
        group        => $dcm4chee::user,
        source       => "${source_directory}${weasis_archive_name}",
        require      => Staging::File["${weasis_archive_name}"],
    }

    staging::file { "${weasis_connector_archive_name}":
        source  => $weasis_connector_source_url,
        target  => "${source_directory}${weasis_connector_archive_name}",
        require => File["${source_directory}"],
    }

    file { "${dcm4chee::staging::dcm4chee_deploy_path}${weasis_connector_archive_name}":
        ensure       => present,
        owner        => $dcm4chee::user,
        group        => $dcm4chee::user,
        source       => "${source_directory}${weasis_connector_archive_name}",
        require      => Staging::File["${weasis_connector_archive_name}"],
    }

    staging::file { "${weasis_dcm4chee_web_name}":
        source  => $weasis_dcm4chee_web_source_url,
        target  => "${source_directory}${weasis_dcm4chee_web_name}",
        require => File["${source_directory}"],
    }

    file { "${dcm4chee::staging::dcm4chee_deploy_path}${weasis_dcm4chee_web_name}":
        ensure       => present,
        owner        => $dcm4chee::user,
        group        => $dcm4chee::user,
        source       => "${source_directory}${weasis_dcm4chee_web_name}",
        require      => Staging::File["${weasis_dcm4chee_web_name}"],
    }
}
