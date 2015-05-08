# Define resources to download and extract files to set up dcm4chee staging
# directory
class dcm4chee::staging (
    $user = $::dcm4chee::params::user,
    $path = $::dcm4chee::params::staging_path,
    $dcm4chee_version = $::dcm4chee::params::dcm4chee_version,
    $jboss_version = $::dcm4chee::params::jboss_version,
) inherits dcm4chee::params {
    $archive_basename = $::dcm4chee::params::archive_basename

    $dcm4chee_home_path = "${path}${archive_basename}/"
    $dcm4chee_bin_path = "${dcm4chee_home_path}${::dcm4chee::params::bin_rel_path}"
    $dcm4chee_deploy_path = "${dcm4chee_home_path}${::dcm4chee::params::server_deploy_rel_path}"

    $jboss_extract_path = "${path}jboss-${jboss_version}/"

    $dcm4chee_archive_name = "${archive_basename}.zip"
    $dcm4chee_base_url = 'http://sourceforge.net/projects/dcm4che/files/dcm4chee/'
    $dcm4chee_source_url = "${dcm4chee_base_url}${dcm4chee_version}/${dcm4chee_archive_name}/download"

    class { '::staging':
        path  => $path,
        owner => $user,
        group => $user,
    }

    staging::deploy { $dcm4chee_archive_name:
        source => $dcm4chee_source_url,
        target => $path,
        user   => $user,
        group  => $user,
    }

    class { 'dcm4chee::staging::replace_jai_imageio_with_64bit':
        require => Staging::Deploy["$dcm4chee_archive_name"],
    }

    class { 'dcm4chee::staging::jboss':
        jboss_version => $jboss_version,
    }

    exec { "${dcm4chee_bin_path}install_jboss.sh":
        cwd     => $path,
        user    => $user,
        command => "${dcm4chee_bin_path}install_jboss.sh ${jboss_extract_path}",
        require => [ Staging::Deploy["$dcm4chee_archive_name"], Class['dcm4chee::staging::jboss'] ],
    }

    file { "${dcm4chee_bin_path}run.sh":
        ensure  => present,
        owner   => $user,
        source  => "${jboss_extract_path}bin/run.sh",
        require => Exec["${dcm4chee_bin_path}install_jboss.sh"],
    }

    class { 'dcm4chee::staging::weasis':
        require => File["${dcm4chee_bin_path}run.sh"],
    }
}

