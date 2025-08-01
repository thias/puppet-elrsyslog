# Main class, can be safely included on all RHEL nodes.
#
class elrsyslog (
  $conf_d_purge           = false,
  $systemd_listen_file    = true,
  # rsyslog.conf parameters
  $preservefqdn           = false,
  $workdirectory          = undef,
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

  $elv = $facts['os']['release']['major']
  # Stop trying to have a single template handle all EL versions
  if versioncmp($elv, '10') >= 0 {
    $rsyslog_template = 'rsyslog-el10.conf.erb'
  } else {
    $rsyslog_template = 'rsyslog.conf.erb'
  }
  file { '/etc/rsyslog.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${rsyslog_template}"),
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

  # Leave the systemd /etc/rsyslog.d/listen.conf file from systemd rpm alone
  if versioncmp($elv, '7') == 0 and $systemd_listen_file {
    elrsyslog::file { 'listen':
      prefix  => false,
      content => "\$SystemLogSocketName /run/systemd/journal/syslog\n",
    }
  }

  # Additional rpm packages
  elrsyslog::package { 'elasticsearch': ensure => $elasticsearch }
  elrsyslog::package { 'relp':          ensure => $relp }

}
