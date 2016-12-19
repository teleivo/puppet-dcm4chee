# See README.md for documentation.
define dcm4chee::default::entry (
  $value,
  $ensure      = 'present',
  $param       = $title,
  $order       = '10',
  $quote_char  = undef,
) {
  validate_string($value)

  include '::dcm4chee'
  $_config_file = '/etc/default/dcm4chee'

  if ! $quote_char {
  # lint:ignore:empty_string_assignment
    $_quote_char = ''
  # lint:endignore
  } else {
    $_quote_char = $quote_char
  }

  if ! defined(Concat[$_config_file]) {
    concat { $_config_file:
      owner          => 'root',
      group          => 'root',
      mode           => '0644',
      ensure_newline => true,
    }
  }

  $_content = inline_template('export <%= @param %>=<%= @_quote_char %><%= @value %><%= @_quote_char %>')
  concat::fragment { "default-${name}":
      ensure  => $ensure,
      target  => $_config_file,
      content => $_content,
      order   => $order,
      notify  => Class['dcm4chee::service'],
  }

}

