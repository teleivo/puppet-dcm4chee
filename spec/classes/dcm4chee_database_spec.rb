require 'spec_helper'

describe 'dcm4chee::database', :type => :class do
  
  [ 'mysql', 'postgresql' ].each do |database_type|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type},
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_anchor('dcm4chee::database::begin')
            .that_comes_before("dcm4chee::database::#{database_type}")
      }
      it { is_expected.to contain_class("dcm4chee::database::#{database_type}")
            .that_comes_before('Anchor[dcm4chee::database::end]')
      }
      it { is_expected.to contain_anchor('dcm4chee::database::end') }
    end
  end
end

