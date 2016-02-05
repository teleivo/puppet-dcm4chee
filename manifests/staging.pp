# Class: dcm4chee::staging: See README.md for documentation.
# Prepares a staging directory with all archives, files in place
# so installation only copies staging directory to its final destination
class dcm4chee::staging () {

  $dcm4chee_home_path = $::dcm4chee::staging_dcm4chee_home_path
  $dcm4chee_bin_path = "${dcm4chee_home_path}${::dcm4chee::dcm4chee_bin_rel_path}"
  $dcm4chee_deploy_path =
  "${dcm4chee_home_path}${::dcm4chee::dcm4chee_server_deploy_rel_path}"
  $dcm4chee_server_conf_path =
  "${dcm4chee_home_path}${::dcm4chee::dcm4chee_server_conf_rel_path}"

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

  ::staging::deploy { $dcm4chee_archive_name:
    source  => $dcm4chee_source_url,
    target  => $::dcm4chee::staging_path,
    user    => $::dcm4chee::user,
    group   => $::dcm4chee::user,
    require => File[$::dcm4chee::staging_path],
  }

  if $::dcm4chee::server {
    class { '::dcm4chee::staging::jai_imageio':
      require => Staging::Deploy[$dcm4chee_archive_name],
    }

    class { '::dcm4chee::staging::jboss':
      require => File[$::dcm4chee::staging_path],
    }

    # Copies jboss files over to dcm4chee
    # Custom script checks if run.jar is already in
    # destinations bin folder, if so install_jboss.sh
    # does not need to be run
    $validate_jboss_installed =
    '/usr/local/bin/validate_dcm4chee_jboss_installed.sh'
    file { $validate_jboss_installed:
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source =>
      'puppet:///modules/dcm4chee/validate_dcm4chee_jboss_installed.sh',
    }

    $unless_cmd = join([$validate_jboss_installed, $dcm4chee_home_path ], ' ')
    exec { "${dcm4chee_bin_path}install_jboss.sh":
      unless  => $unless_cmd,
      command => "${dcm4chee_bin_path}install_jboss.sh ${jboss_extract_path}",
      cwd     => $::dcm4chee::staging_path,
      user    => $::dcm4chee::user,
      path    => '/bin:/usr/bin:/usr/local/bin',
      require => [
        Staging::Deploy[$dcm4chee_archive_name],
        Class['dcm4chee::staging::jboss'],
        File[$validate_jboss_installed],
      ],
    }

    # Replacing run.sh coming with dcm4chee archive due to
    # bug http://www.dcm4che.org/jira/browse/DCMEE-2090
    # which is fixed in run.sh coming with jboss 4.2.3.GA archive
    file { "${dcm4chee_bin_path}run.sh":
      ensure  => file,
      owner   => $::dcm4chee::user,
      group   => $::dcm4chee::user,
      source  => "${jboss_extract_path}bin/run.sh",
      require => Exec["${dcm4chee_bin_path}install_jboss.sh"],
    }
  
    if $::dcm4chee::weasis {
      class { '::dcm4chee::staging::weasis':
        require => File["${dcm4chee_bin_path}run.sh"],
      }
    }

    # Important Note: hack to prevent dcm4chee::install
    # from overriding dcm4chee::config's work
    # which manages these files
    $db_connection_file = $::dcm4chee::database_type ? {
      'postgresql' => 'pacs-postgres-ds.xml',
      'mysql'      => 'pacs-mysql-ds.xml',
    }
    file {[
      "${dcm4chee_deploy_path}${db_connection_file}",
      "${dcm4chee_deploy_path}jboss-web.deployer/server.xml",
      "${dcm4chee_bin_path}run.conf",
      "${dcm4chee_server_conf_path}jboss-log4j.xml",
    ]:
      ensure => absent,
    }
  }
}

