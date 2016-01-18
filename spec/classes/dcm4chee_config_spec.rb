require 'spec_helper'

describe 'dcm4chee::config', :type => :class do

    context 'without parameters' do
      it { is_expected.to contain_class('dcm4chee::config::mysql') }
      it { is_expected.to contain_class('dcm4chee::config::jboss') }
      it { is_expected.to contain_class('dcm4chee::config::weasis') }
    end
end

