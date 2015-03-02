define elrsyslog::file (
  $ensure  = 'file',
  $prefix  = '50',
  $content = undef,
  $source  = undef,
) {

  file { "/etc/rsyslog.d/${prefix}-${title}.conf":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
    source  => $source,
    notify  => Service['rsyslog'],
  }

}
