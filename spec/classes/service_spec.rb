require 'spec_helper'

describe 'dcm4chee::service', :type => :class do
  let(:params) {
    {
      :jboss_home_path => '/opt/dcm4chee/dcm4chee-2.18.0-mysql/jboss/',
      :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java'
    }
  }

  context 'with standard conditions' do
    it { is_expected.to contain_service('dcm4chee').with(
      'name'   => 'dcm4chee',
      'ensure' => 'running',
      'enable' => 'true'
    ) }
    it { is_expected.to contain_file('/etc/init.d/dcm4chee') }
  end
end

