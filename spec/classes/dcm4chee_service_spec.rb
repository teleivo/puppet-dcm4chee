require 'spec_helper'

describe 'dcm4chee::service', :type => :class do
  
  describe 'with defaults and server_java_path set' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_service('dcm4chee')
          .only_with(
            'name'   => 'dcm4chee',
            'ensure' => 'running',
            'enable' => 'true',
          )
    }
  end
end

