require 'spec_helper'

describe 'dcm4chee::install', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-mysql/').with({
      'source'  => '/opt/dcm4chee/staging/dcm4chee-2.18.0-mysql/',
      'recurse' => true,
    }) }
    it { is_expected.to contain_mysql_database('pacsdb') }
    it { is_expected.to contain_mysql_user('dcm4chee@localhost') }
  end
end

