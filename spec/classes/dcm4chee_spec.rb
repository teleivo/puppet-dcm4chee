require 'spec_helper'

describe 'dcm4chee', :type => :class do

  let :valid_required_params do
    {
      :server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
    }
  end

  context 'on Ubuntu 14.04 64bit' do

    context 'with server = true and database = true and server_java_path set' do
      let :params do
        valid_required_params
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('dcm4chee') }
      it { is_expected.to contain_user('dcm4chee') }
      it { is_expected.to contain_class('dcm4chee::staging').that_comes_before('dcm4chee::database') }
      it { is_expected.to contain_class('dcm4chee::database').that_comes_before('dcm4chee::install') }
      it { is_expected.to contain_class('dcm4chee::install').that_comes_before('dcm4chee::config') }
      it { is_expected.to contain_class('dcm4chee::config') }
      it { is_expected.to contain_class('dcm4chee::service').that_subscribes_to('dcm4chee::config') }
    end

    context 'with server = true and database = false' do
      let :params do
        valid_required_params.merge({
          :database => false,
        })
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('dcm4chee') }
      it { is_expected.to contain_user('dcm4chee') }
      it { is_expected.to contain_class('dcm4chee::staging') }
      it { is_expected.not_to contain_class('dcm4chee::database') }
      it { is_expected.to contain_class('dcm4chee::install').that_comes_before('dcm4chee::config') }
      it { is_expected.to contain_class('dcm4chee::config') }
      it { is_expected.to contain_class('dcm4chee::service').that_subscribes_to('dcm4chee::config') }
    end

    context 'with server = false and database = true' do
      let :params do
        {
          :server   => false,
          :database => true,
        }
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('dcm4chee') }
      it { is_expected.to contain_user('dcm4chee') }
      it { is_expected.to contain_class('dcm4chee::staging').that_comes_before('dcm4chee::database') }
      it { is_expected.to contain_class('dcm4chee::database') }
      it { is_expected.not_to contain_class('dcm4chee::install') }
      it { is_expected.not_to contain_class('dcm4chee::config') }
      it { is_expected.not_to contain_class('dcm4chee::service') }
    end

    context 'with invalid parameters' do
      describe 'given non boolean server' do
        let :params do
          valid_required_params.merge({
            :server => 'NOTBOOLEAN',
          })
        end
        it { should_not compile }
      end
      describe 'given server_version other than "2.18.0"' do
        let :params do
          valid_required_params.merge({
            :server => '2.18.1',
          })
        end
        it { should_not compile }
      end
      describe 'given non string server_host' do
        let :params do
          valid_required_params.merge({
            :server_host => true,
          })
        end
        it { should_not compile }
      end
      describe 'given no server_java_path when server=true' do
        it { should_not compile }
      end
      describe 'given non absolute server_java_path' do
        let :params do
          valid_required_params.merge({
            :server_java_path => 'usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
          })
        end
        it { should_not compile }
      end
      describe 'given non array server_java_opts' do
        let :params do
          valid_required_params.merge({
            :server_java_opts => '-Xms512m, -Xmx1024m',
          })
        end
        it { should_not compile }
      end
      describe 'given no server_java_path when server = true' do
        it { should_not compile }
      end
      describe 'given non string user' do
        let :params do
          valid_required_params.merge({
            :user => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non absolute user_home' do
        let :params do
          valid_required_params.merge({
            :user_home => 'opt/dcm4chee',
          })
        end
        it { should_not compile }
      end
      describe 'given non absolute home_path' do
        let :params do
          valid_required_params.merge({
            :home_path => 'opt/dcm4chee/dcm4chee-2.18.0-mysql',
          })
        end
        it { should_not compile }
      end
      describe 'given non absolute staging_home_path' do
        let :params do
          valid_required_params.merge({
            :staging_home_path => 'opt/dcm4chee/staging',
          })
        end
        it { should_not compile }
      end
      describe 'given non boolean database' do
        let :params do
          valid_required_params.merge({
            :database => 'NOTBOOLEAN',
          })
        end
        it { should_not compile }
      end
      describe 'given database_type other than "mysql" or "postgresql"' do
        let :params do
          valid_required_params.merge({
            :server => 'mongodb',
          })
        end
        it { should_not compile }
      end
      describe 'given non string database_host' do
        let :params do
          valid_required_params.merge({
            :database_host => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non integer database_port' do
        let :params do
          valid_required_params.merge({
            :database_port => 'UpsNotANumber',
          })
        end
        it { should_not compile }
      end
      describe 'given database_port < 0' do
        let :params do
          valid_required_params.merge({
            :database_port => '-1',
          })
        end
        it { should_not compile }
      end
      describe 'given database_port > 65535' do
        let :params do
          valid_required_params.merge({
            :database_port => '65536',
          })
        end
        it { should_not compile }
      end
      describe 'given non string database_name' do
        let :params do
          valid_required_params.merge({
            :database_name => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non string database_owner_password' do
        let :params do
          valid_required_params.merge({
            :database_owner_password => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non integer server_http_port' do
        let :params do
          valid_required_params.merge({
            :server_http_port => 'UpsNotANumber',
          })
        end
        it { should_not compile }
      end
      describe 'given server_http_port < 0' do
        let :params do
          valid_required_params.merge({
            :server_http_port => '-1',
          })
        end
        it { should_not compile }
      end
      describe 'given server_http_port > 65535' do
        let :params do
          valid_required_params.merge({
            :server_http_port => '65536',
          })
        end
        it { should_not compile }
      end
      describe 'given non integer server_ajp_connector_port' do
        let :params do
          valid_required_params.merge({
            :server_ajp_connector_port => 'UpsNotANumber',
          })
        end
        it { should_not compile }
      end
      describe 'given server_ajp_connector_port < 0' do
        let :params do
          valid_required_params.merge({
            :server_ajp_connector_port => '-1',
          })
        end
        it { should_not compile }
      end
      describe 'given server_ajp_connector_port > 65535' do
        let :params do
          valid_required_params.merge({
            :server_ajp_connector_port => '65536',
          })
        end
        it { should_not compile }
      end
      describe 'given non string server_dicom_aet' do
        let :params do
          valid_required_params.merge({
            :server_dicom_aet => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non integer server_dicom_port' do
        let :params do
          valid_required_params.merge({
            :server_dicom_port => 'UpsNotANumber',
          })
        end
        it { should_not compile }
      end
      describe 'given server_dicom_port < 0' do
        let :params do
          valid_required_params.merge({
            :server_dicom_port => '-1',
          })
        end
        it { should_not compile }
      end
      describe 'given server_dicom_port > 65535' do
        let :params do
          valid_required_params.merge({
            :server_dicom_port => '65536',
          })
        end
        it { should_not compile }
      end
      describe 'given server = false and database = false' do
        let :params do
          valid_required_params.merge({
            :server   => false,
            :database => false,
          })
        end
        it { should_not compile }
      end
      describe 'given non boolean dicom_webviewer' do
        let :params do
          valid_required_params.merge({
            :dicom_webviewer => 'NOTBOOLEAN',
          })
        end
        it { should_not compile }
      end
      describe 'given non array dicom_webviewer_hosts_allow' do
        let :params do
          valid_required_params.merge({
            :dicom_webviewer_hosts_allow => 'localhost, 192.168.1.11',
          })
        end
        it { should_not compile }
      end
    end
  end

  context 'should gracefully fail on any OS other than Ubuntu 14.04 64bit' do
    [
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '14.04',
        :architecture           => 'x86',
      },
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.02',
        :architecture           => 'amd64',
      },
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '7',
        :architecture           => 'amd64',
      },
    ].each do |facts|
      let(:facts) { facts }
      it "should fail on #{facts[:operatingsystem]} #{facts[:operatingsystemrelease]} #{facts[:architecture]}" do
        is_expected.to compile.and_raise_error(/Module only supports Ubuntu 14.04 64bit/)
      end
    end
  end
end

