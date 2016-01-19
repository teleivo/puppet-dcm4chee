require 'spec_helper'

describe 'dcm4chee::install', :type => :class do
  
  describe 'with defaults and server_java_path set' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-psql/').with({
      'source'  => '/opt/dcm4chee/staging/dcm4chee-2.18.0-psql/',
      'recurse' => true,
    }) }
  end

  describe 'with defaults, server_java_path set and database_type=mysql' do
    let :pre_condition do
      "class {'dcm4chee':
         database_type    => 'mysql',
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-mysql/').with({
      'source'  => '/opt/dcm4chee/staging/dcm4chee-2.18.0-mysql/',
      'recurse' => true,
    }) }
  end
end

