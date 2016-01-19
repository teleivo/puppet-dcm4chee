require 'spec_helper'

describe 'dcm4chee::database', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_mysql__db('pacsdb')
      .with({
        'user'     => 'dcm4chee',
        'password' => 'dcm4chee',
        'host'     => 'localhost',
        'grant'    => ['ALL'],
        'sql'      => "/opt/dcm4chee/staging/dcm4chee-2.18.0-mysql/sql//create.mysql",
      }).that_requires('Staging::Deploy[dcm4chee-2.18.0-mysql.zip]')
    } 
    it { is_expected.to contain_mysql_database('pacsdb') }
    it { is_expected.to contain_mysql_user('dcm4chee@localhost') }
  end

  describe 'when pacs server is on different host than database' do
    let :pre_condition do
      "class {'dcm4chee':
         server      => false,
         server_host => 'pacs.example.com',
       }"
    end

    it { is_expected.to contain_mysql__db('pacsdb')
      .with({
        'user'     => 'dcm4chee',
        'password' => 'dcm4chee',
        'host'     => 'pacs.example.com',
        'grant'    => ['ALL'],
        'sql'      => "/opt/dcm4chee/staging/dcm4chee-2.18.0-mysql/sql//create.mysql",
      }).that_requires('Staging::Deploy[dcm4chee-2.18.0-mysql.zip]')
    }
    it { is_expected.to contain_mysql_database('pacsdb') }
    it { is_expected.to contain_mysql_user('dcm4chee@pacs.example.com') }
  end
end

