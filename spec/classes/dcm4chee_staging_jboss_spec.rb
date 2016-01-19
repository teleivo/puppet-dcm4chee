require 'spec_helper'

describe 'dcm4chee::staging::jboss', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_staging__deploy('jboss-4.2.3.GA.zip')
          .with({
            'source'  => 'http://sourceforge.net/projects/jboss/files/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip',
            'target'  => '/opt/dcm4chee/staging/',
            'user'    => 'dcm4chee',
            'group'   => 'dcm4chee',
          })
    }
 end
end

