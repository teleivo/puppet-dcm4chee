class dcm4chee::staging::jboss () {
  $jboss_archive_basename = "jboss-${dcm4chee::jboss_version}"
  $jboss_archive_name = "${jboss_archive_basename}.zip"
  $jboss_base_url = 'http://sourceforge.net/projects/jboss/files/JBoss/JBoss-'
  $jboss_source_url = "${jboss_base_url}${dcm4chee::jboss_version}/${jboss_archive_name}"

  staging::deploy { $jboss_archive_name:
    source => $jboss_source_url,
    target => $dcm4chee::staging_path,
    user   => $dcm4chee::user,
    group  => $dcm4chee::user,
  }
}
