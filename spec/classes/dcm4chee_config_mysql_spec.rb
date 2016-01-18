require 'spec_helper'

describe 'dcm4chee::config::mysql', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-mysql/server/default/deploy/pacs-mysql-ds.xml')
          .with({
            'ensure'  => 'file',
            'owner'   => 'dcm4chee',
            'group'   => 'dcm4chee',
            'mode'    => '0644',
          })
    }
 end
end

