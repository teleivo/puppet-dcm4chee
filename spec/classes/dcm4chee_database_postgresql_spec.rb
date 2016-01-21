require 'spec_helper'

describe 'dcm4chee::database::postgresql', :type => :class do

  describe 'with defaults and server=false' do
    let :pre_condition do
      "class {'dcm4chee':
         server => false,
       }"
    end

    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_postgresql__server__db('pacsdb')
      .with({
        'owner'    => 'dcm4chee',
        'user'     => 'dcm4chee',
        'password' => 'md5e3afa920474283167b7537ac7b9561a4', #md5 hash of 'dcm4chee'
        'grant'    => 'ALL',
      }).that_requires('Staging::Deploy[dcm4chee-2.18.0-psql.zip]')
    }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('dcm4chee_ident')
      .with({
        'description' => 'allow local ident access for dcm4chee',
        'database'    => 'pacsdb',
        'user'        => 'dcm4chee',
        'type'        => 'local',
        'auth_method' => 'ident',
      })
    }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('dcm4chee_host')
      .with({
        'description' => 'allow host md5 access for dcm4chee',
        'database'    => 'pacsdb',
        'user'        => 'dcm4chee',
        'type'        => 'host',
        'address'     => 'localhost',
        'auth_method' => 'md5',
      })
    }
    it { is_expected.to contain_postgresql__validate_db_connection('pacsdb-connection')
      .with({
        'database_name'     => 'pacsdb',
        'database_port'     => '5432',
        'run_as'            => 'dcm4chee',
      })
      .that_requires('Postgresql::Server::Db[pacsdb]')
    }
    it { is_expected.to contain_file('/usr/local/bin/validate_dcm4chee_database_created.sh')
      .with({
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
        'source' => 'puppet:///modules/dcm4chee/validate_dcm4chee_database_created.sh',
      })
    }
    it { is_expected.to contain_exec('create database pacsdb for dcm4chee')
      .with({
        'unless'    => '/usr/local/bin/validate_dcm4chee_database_created.sh pacsdb ae 5432',
        'command'   => '/usr/bin/psql --quiet --tuples-only -p 5432 --dbname pacsdb -f create.psql',
        'cwd'       => '/opt/dcm4chee/staging/dcm4chee-2.18.0-psql/sql/',
        'user'      => 'dcm4chee',
        'logoutput' => 'on_failure',
        'path'      => '/bin:/usr/bin:/usr/local/bin',
      })
      .that_requires('Class[postgresql::client]')
      .that_requires('Postgresql::Server::Db[pacsdb]')
      .that_requires('Postgresql::Validate_db_connection[pacsdb-connection]')
      .that_requires('File[/usr/local/bin/validate_dcm4chee_database_created.sh]')
    }
  end

  describe 'with server=false and custom user, database_name, server_host, database_port, database_owner_password' do
    let :pre_condition do
      "class {'dcm4chee':
         server                  => false,
         user                    => 'felix',
         database_name           => 'medpacs',
         server_host             => '192.168.1.11',
         database_port           => '5435',
         database_owner_password => 'wrong11!',
       }"
    end

    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_postgresql__server__db('medpacs')
      .with({
        'owner'    => 'felix',
        'user'     => 'felix',
        'password' => 'md5160585eed67bba660768b3897dcda203',
        'grant'    => 'ALL',
      }).that_requires('Staging::Deploy[dcm4chee-2.18.0-psql.zip]')
    }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('felix_ident')
      .with({
        'description' => 'allow local ident access for dcm4chee',
        'database'    => 'medpacs',
        'user'        => 'felix',
        'type'        => 'local',
        'auth_method' => 'ident',
      })
    }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('felix_host')
      .with({
        'description' => 'allow host md5 access for dcm4chee',
        'database'    => 'medpacs',
        'user'        => 'felix',
        'type'        => 'host',
        'address'     => '192.168.1.11/32',
        'auth_method' => 'md5',
      })
    }
    it { is_expected.to contain_postgresql__validate_db_connection('medpacs-connection')
      .with({
        'database_name'     => 'medpacs',
        'database_port'     => '5435',
        'run_as'            => 'felix',
      })
      .that_requires('Postgresql::Server::Db[medpacs]')
    }
    it { is_expected.to contain_file('/usr/local/bin/validate_dcm4chee_database_created.sh')
      .with({
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
        'source' => 'puppet:///modules/dcm4chee/validate_dcm4chee_database_created.sh',
      })
    }
    it { is_expected.to contain_exec('create database medpacs for felix')
      .with({
        'unless'    => '/usr/local/bin/validate_dcm4chee_database_created.sh medpacs ae 5435',
        'command'   => '/usr/bin/psql --quiet --tuples-only -p 5435 --dbname medpacs -f create.psql',
        'cwd'       => '/opt/dcm4chee/staging/dcm4chee-2.18.0-psql/sql/',
        'user'      => 'felix',
        'logoutput' => 'on_failure',
        'path'      => '/bin:/usr/bin:/usr/local/bin',
      })
      .that_requires('Class[postgresql::client]')
      .that_requires('Postgresql::Server::Db[medpacs]')
      .that_requires('Postgresql::Validate_db_connection[medpacs-connection]')
      .that_requires('File[/usr/local/bin/validate_dcm4chee_database_created.sh]')
    }
  end

  describe 'with server=false and server_host=pacs.example.com' do
     let :pre_condition do
      "class {'dcm4chee':
         server           => false,
         server_host      => 'pacs.example.com',
       }"
    end

    it { is_expected.to contain_postgresql__server__pg_hba_rule('dcm4chee_host')
      .with({
        'description' => 'allow host md5 access for dcm4chee',
        'database'    => 'pacsdb',
        'user'        => 'dcm4chee',
        'type'        => 'host',
        'address'     => 'pacs.example.com',
        'auth_method' => 'md5',
      })
    }
  end
end

