require 'spec_helper'

describe 'dcm4chee::default::entry', :type => :define do
  let :pre_condition do
    "class {'dcm4chee':
        server_java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
    }"
  end
  let :facts do
    {
      :osfamily       => 'Debian',
      :concat_basedir => '/tmp',
      :id             => 'root',
      :path           => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end
  let :title do
    'LANG'
  end
  context 'no quotes' do
    let :params do
      {
        'value' => 'es_ES.UTF-8',
      }
    end

    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_concat('/etc/default/dcm4chee').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
    }
    it { is_expected.to contain_concat__fragment('default-LANG').with_content(/export LANG=es_ES\.UTF-8/).with({
      'ensure' => 'present',
      'target' => '/etc/default/dcm4chee',
      'order'  => '10',
    })
    .that_notifies('Class[dcm4chee::service]')
    }
  end
  context 'quotes' do
    let :params do
      {
        'value'      => 'es_ES.UTF-8',
        'quote_char' => '"',
      }
    end

    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_concat('/etc/default/dcm4chee').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
    }
    it { is_expected.to contain_concat__fragment('default-LANG').with_content(/export LANG="es_ES\.UTF-8"/).with({
      'ensure' => 'present',
      'target' => '/etc/default/dcm4chee',
      'order'  => '10',
    })
    .that_notifies('Class[dcm4chee::service]')
    }
  end
  context 'ensure absent' do
    let :params do
      {
        'value'  => 'es_ES.UTF-8',
        'ensure' => 'absent',
      }
    end

    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_concat('/etc/default/dcm4chee').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
    }
    it { is_expected.to contain_concat__fragment('default-LANG').with_content(/export LANG=es_ES\.UTF-8/).with({
      'ensure' => 'absent',
      'target' => '/etc/default/dcm4chee',
    })
    .that_notifies('Class[dcm4chee::service]')
    }
  end
  context 'order' do
    let :params do
      {
        'param' => 'BAR',
        'value' => 'es_ES.UTF-8',
        'order' => '20',
      }
    end

    it { is_expected.to contain_class('dcm4chee') }
    it { is_expected.to contain_concat('/etc/default/dcm4chee').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
    }
    it { is_expected.to contain_concat__fragment('default-LANG').with_content(/export BAR=es_ES\.UTF-8/).with({
      'ensure' => 'present',
      'target' => '/etc/default/dcm4chee',
      'order'  => '20',
    })
    .that_notifies('Class[dcm4chee::service]')
    }
  end
end
