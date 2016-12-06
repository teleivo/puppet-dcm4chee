require 'spec_helper'

describe 'dcm4chee::service', :type => :class do
  
  describe 'with defaults and server_java_path set' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/etc/init.d/dcm4chee')
          .that_notifies('Service[dcm4chee]')
          .with_content(/^JBOSS_HOME=\${JBOSS_HOME:-"\/opt\/dcm4chee\/dcm4chee-2\.18\.1-psql\/"/)
          .with_content(/^JAVAPTH=\${JAVAPTH:-"\/usr\/lib\/jvm\/java-7-openjdk-amd64\/jre\/bin\/java"/)
    }
    it { is_expected.to contain_service('dcm4chee')
          .only_with(
            'name'       => 'dcm4chee',
            'ensure'     => 'running',
            'enable'     => 'true',
            'provider'   => 'init',
            'hasrestart' => 'true',
          )
    }
  end
  describe 'with server_service_enable=false' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path      => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
         server_service_enable => false,
       }"
    end

    it { is_expected.to contain_file('/etc/init.d/dcm4chee')
          .that_notifies('Service[dcm4chee]')
          .with_content(/^JBOSS_HOME=\${JBOSS_HOME:-"\/opt\/dcm4chee\/dcm4chee-2\.18\.1-psql\/"/)
          .with_content(/^JAVAPTH=\${JAVAPTH:-"\/usr\/lib\/jvm\/java-7-openjdk-amd64\/jre\/bin\/java"/)
    }
    it { is_expected.to contain_service('dcm4chee')
          .only_with(
            'name'       => 'dcm4chee',
            'ensure'     => 'running',
            'enable'     => 'false',
            'provider'   => 'init',
            'hasrestart' => 'true',
          )
    }
  end
  describe 'with server_service_ensure=stopped' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path      => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
         server_service_ensure => 'stopped',
       }"
    end

    it { is_expected.to contain_file('/etc/init.d/dcm4chee')
          .that_notifies('Service[dcm4chee]')
          .with_content(/^JBOSS_HOME=\${JBOSS_HOME:-"\/opt\/dcm4chee\/dcm4chee-2\.18\.1-psql\/"/)
          .with_content(/^JAVAPTH=\${JAVAPTH:-"\/usr\/lib\/jvm\/java-7-openjdk-amd64\/jre\/bin\/java"/)
    }
    it { is_expected.to contain_service('dcm4chee')
          .only_with(
            'name'       => 'dcm4chee',
            'ensure'     => 'stopped',
            'enable'     => 'true',
            'provider'   => 'init',
            'hasrestart' => 'true',
          )
    }
  end
end

