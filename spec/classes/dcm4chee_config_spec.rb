require 'spec_helper'

describe 'dcm4chee::config', :type => :class do

  [ 'mysql', 'postgresql' ].each do |database_type|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type},
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_anchor('dcm4chee::config::begin')
            .that_comes_before("dcm4chee::config::#{database_type}")
            .that_comes_before('dcm4chee::config::weasis')
      }
      it { is_expected.to contain_class("dcm4chee::config::#{database_type}")
            .that_comes_before('dcm4chee::config::jboss')
      }
      it { is_expected.to contain_class('dcm4chee::config::jboss')
            .that_comes_before('dcm4chee::config::weasis')
            .that_comes_before('Anchor[dcm4chee::config::end]')
      }
      it { is_expected.to contain_class('dcm4chee::config::weasis')
            .that_comes_before('Anchor[dcm4chee::config::end]')
      }
      it { is_expected.to contain_anchor('dcm4chee::config::end') }
    end
  end

  describe 'with defaults and weasis = false' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
         weasis => false,
       }"
    end

    it { is_expected.to contain_class('dcm4chee::config::postgresql')
          .that_comes_before('dcm4chee::config::jboss')
    }
    it { is_expected.to contain_class('dcm4chee::config::jboss') }
    it { is_expected.not_to contain_class('dcm4chee::config::weasis') }
  end
end

