require 'spec_helper'

describe 'dcm4chee::staging', :type => :class do
  
  describe 'without parameters' do
    let :pre_condition do
      "class {'dcm4chee':
         java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
       }"
    end

    it { is_expected.to contain_class('staging') }
    it { is_expected.to contain_file('/opt/dcm4chee/staging/').with({
      'ensure' => 'directory',
      'owner'  => 'dcm4chee',
      'group'  => 'dcm4chee',
    }) }
    it { is_expected.to contain_class('dcm4chee::staging::replace_jai_imageio_with_64bit') }
    it { is_expected.to contain_class('dcm4chee::staging::jboss') }
    it { is_expected.to contain_class('dcm4chee::staging::weasis') }
 end
end

