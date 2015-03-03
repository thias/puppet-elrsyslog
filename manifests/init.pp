# Main class
#
class elrsyslog (
  $conf_d_purge           = false,
  $systemd_listen_file    = true,
  # rsyslog.conf parameters
  $preservefqdn           = false,
  $workdirectory          = undef,
  $rules_messages_default = '*.info;mail.none;authpriv.none;cron.none',
  $rules_messages_extra   = '',
  $rules_extra            = {},
  $local0_file            = undef,
  $local1_file            = undef,
  $local2_file            = undef,
  $local3_file            = undef,
  $local4_file            = undef,
  $local5_file            = undef,
  $local6_file            = undef,
  # Extra rpm packages, individually to make it easier to override from hiera
  $elasticsearch          = undef,
  $relp                   = undef,
) {

  package { 'rsyslog': ensure => 'installed' }

  service { 'rsyslog':
    ensure  => 'running',
    enable  => true,
    require => Package['rsyslog'],
  }

  $elv = $operatingsystemmajrelease
  file { '/etc/rsyslog.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/rsyslog.conf.erb"),
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
  }

  file { '/etc/rsyslog.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => $conf_d_purge,
    purge   => $conf_d_purge,
    # el7 glusterfs-libs creates gluster.conf.example
    ignore  => '*.example',
    require => Package['rsyslog'],
  }

  # Leave the systemd /etc/rsyslog.d/listen.conf file alone
  if $elv >= 7 and $systemd_listen_file {
    elrsyslog::file { 'listen':
      prefix => false,
      content => "\$SystemLogSocketName /run/systemd/journal/syslog\n",
    }
  }

  # Additional rpm packages
  elrsyslog::package { 'elasticsearch': ensure => $elasticsearch }
  elrsyslog::package { 'relp':          ensure => $relp }

}
