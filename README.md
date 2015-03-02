# Overview

Rsyslog module for Red Hat Enterprise Linux 6 and newer.
Supported versions are :

 * RHEL6 : `rsyslog-5.8.10`
 * RHEL7 : `rsyslog-7.4.7`

This module is basically just an rsyslog.conf template on steroids, where that
single template replicates the exact original file shipped with RHEL, so that
applying the module with default parameters does not change anthing, making it
trivial to audit and follow deviations from the defaults.

If you are looking for an rsyslog module supporting other GNU/Linux
distributions and Operating Systems, such as Debian, Ubuntu, FreeBSD, etc.
this it *not* the module for you, and you should check out these instead :

 * https://forge.puppetlabs.com/ghoneycutt/rsyslog
 * https://forge.puppetlabs.com/saz/rsyslog

Given the above, to be able to co-exist with other rsyslog modules,
this module has been named 'elrsyslog'.

# Examples

```yaml
classes:
  - '::elrsyslog'
elrsyslog::preservefqdn: true
```

