require 'spec_helper'

describe 'dcm4chee', :type => :class do
  let(:params) { { :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java' } }

  context 'on Ubuntu 14.04 64bit' do
    it { is_expected.to compile }
    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_class('dcm4chee::staging').that_comes_before('dcm4chee::install') }
    it { is_expected.to contain_class('dcm4chee::install').that_comes_before('dcm4chee::config') }
    it { is_expected.to contain_class('dcm4chee::config') }
    it { is_expected.to contain_class('dcm4chee::service').that_subscribes_to('dcm4chee::config') }
    it { is_expected.to contain_user('dcm4chee') }
    it { is_expected.to contain_service('dcm4chee').with(
      'ensure' => 'running'
    ) }

    context 'with invalid parameters' do
      describe 'given non absolute user_home' do
        let(:params) {{
          :user_home => 'opt/dcm4chee',
        }}
        it { should_not compile }
      end
      describe 'given non absolute home_path' do
        let(:params) {{
          :home_path => 'opt/dcm4chee/dcm4chee-2.18.0-mysql',
        }}
        it { should_not compile }
      end
      describe 'given non absolute staging_home_path' do
        let(:params) {{
          :staging_home_path => 'opt/dcm4chee/staging',
        }}
        it { should_not compile }
      end
      describe 'given non string db_host' do
        let(:params) {{
          :db_host => true,
        }}
        it { should_not compile }
      end
      describe 'given non string db_name' do
        let(:params) {{
          :db_name => true,
        }}
        it { should_not compile }
      end
      describe 'given non string db_owner' do
        let(:params) {{
          :db_owner => true,
        }}
        it { should_not compile }
      end
      describe 'given non string db_owner_password' do
        let(:params) {{
          :db_owner_password => true,
        }}
        it { should_not compile }
      end
      describe 'given non integer jboss_http_port' do
        let(:params) {{
          :jboss_http_port => 'UpsNotANumber',
        }}
        it { should_not compile }
      end
      describe 'given jboss_http_port < 0' do
        let(:params) {{
          :jboss_http_port => '-1',
        }}
        it { should_not compile }
      end
      describe 'given jboss_http_port > 65535' do
        let(:params) {{
          :jboss_http_port => '65536',
        }}
        it { should_not compile }
      end
      describe 'given non integer jboss_ajp_connector_port' do
        let(:params) {{
          :jboss_ajp_connector_port => 'UpsNotANumber',
        }}
        it { should_not compile }
      end
      describe 'given jboss_ajp_connector_port < 0' do
        let(:params) {{
          :jboss_ajp_connector_port => '-1',
        }}
        it { should_not compile }
      end
      describe 'given jboss_ajp_connector_port > 65535' do
        let(:params) {{
          :jboss_ajp_connector_port => '65536',
        }}
        it { should_not compile }
      end
    end

    context 'dcm4chee::staging' do
      it { is_expected.to contain_class('staging') }
      it { is_expected.to contain_class('dcm4chee::staging::replace_jai_imageio_with_64bit') }
      it { is_expected.to contain_class('dcm4chee::staging::jboss') }
      it { is_expected.to contain_class('dcm4chee::staging::weasis') }
    end

    context 'dcm4chee::install' do
      it { is_expected.to contain_mysql_database('pacsdb') }
      it { is_expected.to contain_mysql_user('dcm4chee@localhost') }
    end

    context 'dcm4chee::config' do
      it { is_expected.to contain_class('dcm4chee::config::mysql') }
      it { is_expected.to contain_class('dcm4chee::config::jboss') }
      it { is_expected.to contain_class('dcm4chee::config::weasis') }
    end
  end

  context 'should gracefully fail on any OS other than Ubuntu 14.04 64bit' do
    describe 'on Ubuntu 14.04 32bit' do
      let(:facts) {{
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '14.04',
        :architecture           => 'x86',
      }}
      it { is_expected.to compile.and_raise_error(/Module only supports Ubuntu 14.04 64bit/) }
    end

    describe 'on Ubuntu 12.02 64bit' do
      let(:facts) {{
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.02',
        :architecture           => 'amd64',
      }}
      it { is_expected.to compile.and_raise_error(/Module only supports Ubuntu 14.04 64bit/) }
    end

    describe 'on Centos 7' do
      let(:facts) {{
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '7',
        :architecture           => 'amd64',
      }}
      it { is_expected.to compile.and_raise_error(/Module only supports Ubuntu 14.04 64bit/) }
    end
  end

end
