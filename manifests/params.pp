class dcm4chee::params (
    $user = 'dcm4chee',
    $user_home = '/opt/dcm4chee/',
    $staging_path = '/opt/dcm4chee/staging/',
    $execute_staging = 'false',
    $dcm4chee_version = '2.18.0',
    $jboss_version = '4.2.3.GA',
    $db_host = 'localhost',
    $db_name = 'pacsdb',
    $db_owner = 'dcm4chee',
    $db_owner_password = 'dcm4chee',
    $jboss_http_port = '8080',
    $jboss_ajp_connector_port = '8009',
    $jboss_java_opts = undef,
) {
    $archive_basename = "dcm4chee-${dcm4chee_version}-mysql"

    $bin_rel_path = 'bin/'
    $sql_rel_path = 'sql/'
    $server_rel_path = 'server/default/'
    $server_deploy_rel_path = "${server_rel_path}deploy/"
    $server_conf_rel_path = "${server_rel_path}conf/"

    $staging_dcm4chee_home_path = "${staging_path}${archive_basename}/"
    $dcm4chee_home_path = "${user_home}${archive_basename}/"
}
