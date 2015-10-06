require 'spec_helper'

describe 'dcm4chee', :type => :class do
  let(:params) { { :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java' } }

  context 'with standard conditions' do
    it { is_expected.to compile }
    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_class('dcm4chee::staging') }
    it { is_expected.to contain_class('dcm4chee::install') }
    it { is_expected.to contain_class('dcm4chee::config') }
    it { is_expected.to contain_class('dcm4chee::service') }
    it { is_expected.to contain_user('dcm4chee') }
    it { is_expected.to contain_service('pacs-dcm4chee').with(
      'ensure' => 'running'
    ) }
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

  context 'with non absolute path parameters' do
    describe 'given non absolute user_home' do
      let(:params) {{ :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
                       :user_home => 'opt/dcm4chee',
      }}
      it { should_not compile }
    end
    describe 'given non absolute home_path' do
      let(:params) {{ :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
                       :home_path => 'opt/dcm4chee/dcm4chee-2.18.0-mysql',
      }}
      it { should_not compile }
    end
    describe 'given non absolute staging_home_path' do
      let(:params) {{ :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
                       :staging_home_path => 'opt/dcm4chee/staging',
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
