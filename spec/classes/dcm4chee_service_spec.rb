require 'spec_helper'

describe 'dcm4chee::service', :type => :class do
  
  describe 'without defaults and java_path set' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/etc/init.d/dcm4chee')
          .that_notifies('Service[dcm4chee]')
    }
    it { is_expected.to contain_service('dcm4chee')
          .only_with(
            'name'   => 'dcm4chee',
            'ensure' => 'running',
            'enable' => 'true',
          )
    }
  end
end

