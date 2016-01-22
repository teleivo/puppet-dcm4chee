require 'spec_helper'

describe 'dcm4chee::config::mysql', :type => :class do
  
  describe 'with server=false and database_type=mysql' do
    let :pre_condition do
      "class {'dcm4chee':
         server        => false,
         database_type => 'mysql',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-mysql/server/default/deploy/pacs-mysql-ds.xml')
          .with({
            'ensure'  => 'file',
            'owner'   => 'dcm4chee',
            'group'   => 'dcm4chee',
            'mode'    => '0640',
          })
          .with_content(/<connection-url>jdbc:mysql:\/\/localhost:3306\/pacsdb<\/connection-url>/)
          .with_content(/<user-name>dcm4chee<\/user-name>/)
          .with_content(/<password>dcm4chee<\/password>/)
    }
  end

  describe 'with server=false, database_type=mysql and custom user, database_host, database_port, database_password' do
    let :pre_condition do
      "class {'dcm4chee':
         server                  => false,
         user                    => 'felix',
         database_type           => 'mysql',
         database_name           => 'medpacs',
         database_host           => '192.168.1.11',
         database_port           => '5435',
         database_owner_password => 'wrong11!',
       }"
    end

    it { is_expected.to contain_file('/opt/dcm4chee/dcm4chee-2.18.0-mysql/server/default/deploy/pacs-mysql-ds.xml')
          .with({
            'ensure'  => 'file',
            'owner'   => 'felix',
            'group'   => 'felix',
            'mode'    => '0640',
          })
          .with_content(/<connection-url>jdbc:mysql:\/\/192.168.1.11:5435\/medpacs<\/connection-url>/)
          .with_content(/<user-name>felix<\/user-name>/)
          .with_content(/<password>wrong11!<\/password>/)
    }
  end
end

