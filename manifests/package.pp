# Default to undef on purpose, to avoid having many packages inside the
# catalog for nothing.
#
# The $ensure parameter may be any valid value from the package type, as well
# as true or false for convenience.
#
define elrsyslog::package ( $ensure = undef ) {

  if $ensure != undef {
    $ensure_final = $ensure ? {
      true    => 'installed',
      false   => 'absent',
      default => $ensure,
    }
    package { "rsyslog-${title}": ensure => $ensure_final }
  }

}
