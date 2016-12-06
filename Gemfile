source ENV['GEM_SOURCE'] || "https://rubygems.org"

gem 'rake'
gem 'rspec', '~> 3.0'
gem 'rspec-puppet', '~> 2.3'
gem 'rspec-puppet-facts', '>= 1.7'
gem 'puppetlabs_spec_helper', '>= 0.8.0'
gem 'puppet-lint', '>= 2'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-absolute_classname-check'
gem 'puppet-lint-undef_in_function-check'
gem 'puppet-lint-leading_zero-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-file_ensure-check'
gem 'simplecov'
gem 'json', '~> 1.0'
gem 'json_pure', '~> 1.0'
gem 'metadata-json-lint'

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
