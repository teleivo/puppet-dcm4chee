require 'spec_helper'

describe 'dcm4chee::database', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_mysql_database('pacsdb') }
    it { is_expected.to contain_mysql_user('dcm4chee@localhost') }
  end
end

