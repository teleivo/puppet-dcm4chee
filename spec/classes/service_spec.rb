require 'spec_helper'

describe 'dcm4chee::service', :type => :class do
  let(:params) {
    {
      :jboss_home_path => '/opt/dcm4chee/dcm4chee-2.18.0-mysql/jboss/',
      :java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java'
    }
  }

  context 'with standard conditions' do
    it { is_expected.to contain_file('/etc/init.d/dcm4chee').that_notifies('Service[dcm4chee]') }
    it { is_expected.to contain_service('dcm4chee').only_with(
      'name'   => 'dcm4chee',
      'ensure' => 'running',
      'enable' => 'true',
    ) }
  end
end

