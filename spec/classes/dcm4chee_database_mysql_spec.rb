require 'spec_helper'

describe 'dcm4chee::database::mysql', :type => :class do
  
  describe 'with server=false and database_type=mysql' do
    let :pre_condition do
      "class {'dcm4chee':
         server        => false,
         database_type => 'mysql',
       }"
    end

    it { is_expected.to contain_class('mysql::server') }
    it { is_expected.to contain_mysql__db('pacsdb')
      .with({
        'user'     => 'dcm4chee',
        'password' => 'dcm4chee',
        'host'     => 'localhost',
        'grant'    => ['ALL'],
        'sql'      => "/opt/dcm4chee/staging/dcm4chee-2.18.1-mysql/sql//create.mysql",
      }).that_requires('Staging::Deploy[dcm4chee-2.18.1-mysql.zip]')
    } 
    it { is_expected.to contain_mysql_database('pacsdb') }
    it { is_expected.to contain_mysql_user('dcm4chee@localhost') }
  end

  describe 'with server=false, database_type=mysql and custom user, server_host, database_password' do
    let :pre_condition do
      "class {'dcm4chee':
         server                  => false,
         user                    => 'felix',
         database_type           => 'mysql',
         database_name           => 'medpacs',
         server_host             => '192.168.1.11',
         database_owner_password => 'wrong11!',
       }"
    end

    it { is_expected.to contain_class('mysql::server') }
    it { is_expected.to contain_mysql__db('medpacs')
      .with({
        'user'     => 'felix',
        'password' => 'wrong11!',
        'host'     => '192.168.1.11',
        'grant'    => ['ALL'],
        'sql'      => "/opt/dcm4chee/staging/dcm4chee-2.18.1-mysql/sql//create.mysql",
      }).that_requires('Staging::Deploy[dcm4chee-2.18.1-mysql.zip]')
    }
    it { is_expected.to contain_mysql_database('medpacs') }
    it { is_expected.to contain_mysql_user('felix@192.168.1.11') }
  end
end

