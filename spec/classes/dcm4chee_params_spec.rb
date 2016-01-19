require 'spec_helper'

describe 'dcm4chee::params', :type => :class do

  context "on Ubuntu 14.04 64bit" do
    it { is_expected.to contain_dcm4chee__params }

    it "should not contain any resources" do
      should have_resource_count(0)
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

