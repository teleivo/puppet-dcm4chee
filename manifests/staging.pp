# Class: dcm4chee::staging: See README.md for documentation.
# Prepares a staging directory with all archives, files in place
# so installation only copies staging directory to its final destination
class dcm4chee::staging () {
  $dcm4chee_home_path = $::dcm4chee::staging_dcm4chee_home_path
  $dcm4chee_bin_path = "${dcm4chee_home_path}${::dcm4chee::dcm4chee_bin_rel_path}"
  $dcm4chee_deploy_path =
  "${dcm4chee_home_path}${::dcm4chee::dcm4chee_server_deploy_rel_path}"

  $jboss_extract_path = "${::dcm4chee::staging_path}jboss-${::dcm4chee::jboss_version}/"

  $dcm4chee_archive_name = "${::dcm4chee::dcm4chee_archive_basename}.zip"
  $dcm4chee_base_url = 'http://sourceforge.net/projects/dcm4che/files/dcm4chee/'
  $dcm4chee_source_url = "${dcm4chee_base_url}${::dcm4chee::server_version}/${dcm4chee_archive_name}/download"

  include '::staging'

  file { $::dcm4chee::staging_path:
    ensure => directory,
    owner  => $::dcm4chee::user,
    group  => $::dcm4chee::user,
  }

  staging::deploy { $dcm4chee_archive_name:
    source  => $dcm4chee_source_url,
    target  => $::dcm4chee::staging_path,
    user    => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    require => File[$::dcm4chee::staging_path],
  }

  if $::dcm4chee::server {
    class { 'dcm4chee::staging::replace_jai_imageio_with_64bit':
      require => Staging::Deploy[$dcm4chee_archive_name],
    }

    class { 'dcm4chee::staging::jboss':
      require => File[$::dcm4chee::staging_path],
    }

    exec { "${dcm4chee_bin_path}install_jboss.sh":
      cwd     => $::dcm4chee::staging_path,
      user    => $::dcm4chee::user,
      command => "${dcm4chee_bin_path}install_jboss.sh ${jboss_extract_path}",
      require => [
        Staging::Deploy[$dcm4chee_archive_name],
        Class['dcm4chee::staging::jboss']],
    }

    file { "${dcm4chee_bin_path}run.sh":
      ensure  => present,
      owner   => $::dcm4chee::user,
      source  => "${jboss_extract_path}bin/run.sh",
      require => Exec["${dcm4chee_bin_path}install_jboss.sh"],
    }
  
    if $::dcm4chee::dicom_webviewer {
      class { 'dcm4chee::staging::weasis':
        require => File["${dcm4chee_bin_path}run.sh"],
      }
    }
  }
}

