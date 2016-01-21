require 'spec_helper'

describe 'dcm4chee::config', :type => :class do

  describe 'with defaults and server_java_path set' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_class('dcm4chee::config::postgresql')
          .that_comes_before('dcm4chee::config::jboss')
    }
    it { is_expected.to contain_class('dcm4chee::config::jboss')
          .that_comes_before('dcm4chee::config::weasis')
    }
    it { is_expected.to contain_class('dcm4chee::config::weasis') }
    it { is_expected.not_to contain_class('dcm4chee::config::mysql') }
  end

  describe 'with defaults and dicom_webviewer = false' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
         dicom_webviewer  => false,
       }"
    end

    it { is_expected.to contain_class('dcm4chee::config::postgresql')
          .that_comes_before('dcm4chee::config::jboss')
    }
    it { is_expected.to contain_class('dcm4chee::config::jboss') }
    it { is_expected.not_to contain_class('dcm4chee::config::weasis') }
  end

  describe 'with defaults, server_java_path set and database_type=mysql' do
    let :pre_condition do
      "class {'dcm4chee':
         database_type    => 'mysql',
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_class('dcm4chee::config::mysql')
          .that_comes_before('dcm4chee::config::jboss')
    }
    it { is_expected.to contain_class('dcm4chee::config::jboss')
          .that_comes_before('dcm4chee::config::weasis')
    }
    it { is_expected.to contain_class('dcm4chee::config::weasis') }
    it { is_expected.not_to contain_class('dcm4chee::config::postgresql') }
  end
end

