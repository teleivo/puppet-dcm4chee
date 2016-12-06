require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.default_facts = {
    :osfamily                  => 'Debian',
    :operatingsystem           => 'Ubuntu',
    :operatingsystemrelease    => '14.04',
    :operatingsystemmajrelease => '14.04',
    :lsbdistcodename           => 'trusty',
    :architecture              => 'amd64',
    :path                      => '/usr/local/bin:/usr/bin:/bin',
    :concat_basedir            => '/tmp',
  }
end

