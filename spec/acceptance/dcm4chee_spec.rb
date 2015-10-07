require 'spec_helper_acceptance'

describe 'dcm4chee class' do

  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      tmpdir = default.tmpdir('mysql')
      pp = <<-EOS
        class { 'dcm4chee':
          java_path => '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end

