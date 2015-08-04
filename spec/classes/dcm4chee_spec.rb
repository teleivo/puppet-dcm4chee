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
