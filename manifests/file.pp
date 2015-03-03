define elrsyslog::file (
  $ensure  = 'file',
  $prefix  = '50',
  $content = undef,
  $source  = undef,
) {

  if $prefix == undef or $prefix == false or $prefix == '' {
    $filename = "${title}.conf"
  } else {
    $filename = "${prefix}-${title}.conf"
  }

  file { "/etc/rsyslog.d/${filename}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
    source  => $source,
    notify  => Service['rsyslog'],
  }

}
