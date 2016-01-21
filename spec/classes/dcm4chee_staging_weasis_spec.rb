require 'spec_helper'

describe 'dcm4chee::staging::weasis', :type => :class do
  
  { 'mysql' => 'mysql', 'postgresql' => 'psql' }.each do |database_type, database_type_short|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type}, 
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_file('/opt/dcm4chee/staging/weasis/')
            .with({
              'ensure' => 'directory',
              'owner'  => 'dcm4chee',
              'group'  => 'dcm4chee',
            })
      }
      it { is_expected.to contain_staging__file('weasis.war')
            .with({
              'source'  => 'http://sourceforge.net/projects/dcm4che/files/Weasis/2.0.3/weasis.war',
              'target'  => '/opt/dcm4chee/staging/weasis/weasis.war',
            })
            .that_requires('File[/opt/dcm4chee/staging/weasis/]')
      }
      it { is_expected.to contain_file("/opt/dcm4chee/staging/dcm4chee-2.18.0-#{database_type_short}/server/default/deploy/weasis.war")
            .with({
              'ensure'  => 'present',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'source'  => '/opt/dcm4chee/staging/weasis/weasis.war',
            })
            .that_requires('Staging::File[weasis.war]')
      }
      it { is_expected.to contain_staging__file('weasis-pacs-connector.war')
            .with({
              'source'  => 'http://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/5.0.0/weasis-pacs-connector.war',
              'target'  => '/opt/dcm4chee/staging/weasis/weasis-pacs-connector.war',
            })
            .that_requires('File[/opt/dcm4chee/staging/weasis/]')
      }
      it { is_expected.to contain_file("/opt/dcm4chee/staging/dcm4chee-2.18.0-#{database_type_short}/server/default/deploy/weasis-pacs-connector.war")
            .with({
              'ensure'  => 'present',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'source'  => '/opt/dcm4chee/staging/weasis/weasis-pacs-connector.war',
            })
            .that_requires('Staging::File[weasis-pacs-connector.war]')
      }
      it { is_expected.to contain_staging__file('dcm4chee-web-weasis.jar')
            .with({
              'source'  => 'http://sourceforge.net/projects/dcm4che/files/Weasis/weasis-pacs-connector/5.0.0/dcm4chee-web-weasis.jar',
              'target'  => '/opt/dcm4chee/staging/weasis/dcm4chee-web-weasis.jar',
            })
            .that_requires('File[/opt/dcm4chee/staging/weasis/]')
      }
      it { is_expected.to contain_file("/opt/dcm4chee/staging/dcm4chee-2.18.0-#{database_type_short}/server/default/deploy/dcm4chee-web-weasis.jar")
            .with({
              'ensure'  => 'present',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'source'  => '/opt/dcm4chee/staging/weasis/dcm4chee-web-weasis.jar',
            })
            .that_requires('Staging::File[dcm4chee-web-weasis.jar]')
      }
    end
  end
end

