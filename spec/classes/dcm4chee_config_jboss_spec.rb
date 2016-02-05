require 'spec_helper'

describe 'dcm4chee::config::jboss', :type => :class do
  
  { 'mysql' => 'mysql', 'postgresql' => 'psql' }.each do |database_type, database_type_short|
    describe "with defaults, server_java_path set and database_type=#{database_type}" do
      let :pre_condition do
        "class {'dcm4chee':
           database_type    => #{database_type}, 
           server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }"
      end

      it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/server/default/deploy/jboss-web.deployer/server.xml")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'mode'    => '0644',
            })
      }
      it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/bin/run.conf")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'mode'    => '0644',
            })
            .without_content(/^JAVA_OPTS=$/)
            .without_content(/^JAVA_OPTS="\$JAVA_OPTS"$/)
      }
      it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/server/default/conf/jboss-log4j.xml")
            .with({
              'ensure'  => 'file',
              'owner'   => 'dcm4chee',
              'group'   => 'dcm4chee',
              'mode'    => '0644',
            })
      }
    end

    describe "with database_type=#{database_type} and custom server_java_opts" do
        let :pre_condition do
          "class {'dcm4chee':
            database_type    => #{database_type},
            server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
            server_java_opts => [ '-Xms256m', '-Xmx1024m', '-XX:MaxPermSize=512m' ],
          }"
        end

        it { is_expected.to contain_file("/opt/dcm4chee/dcm4chee-2.18.1-#{database_type_short}/bin/run.conf")
              .with({
                'ensure'  => 'file',
                'owner'   => 'dcm4chee',
                'group'   => 'dcm4chee',
                'mode'    => '0644',
              })
              .with_content(/^JAVA_OPTS="\$JAVA_OPTS -Xms256m"$/)
              .with_content(/^JAVA_OPTS="\$JAVA_OPTS -Xmx1024m"$/)
              .with_content(/^JAVA_OPTS="\$JAVA_OPTS -XX:MaxPermSize=512m"$/)
        }
    end
  end
end

