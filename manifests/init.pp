# == Class: ensuretlsv
#
# Ensure communication between Master & Agent components secured over TLSv1.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'ensuretlsv':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# David Bryant-Moore <david.bmoore@puppetlabs.com>
#
# === Copyright
#
# Copyright 2015 Puppetlabs.
#
class ensuretls (
  $encryptionmode = $ensuretls::params::encryptionmode
)
inherits ensuretls::params {

  $confpath='/etc/puppetlabs/httpd/conf.d'
  $protocol = split($encryptionmode,' ')

  File_line {
    line   => $encryptionmode,
    ensure => present,
    match  => "^\\s+SSLProtocol\\s+",
  }

  file_line {'ssl.conf':
    path  => "${confpath}/ssl.conf",
  }

  file_line {'puppetproxy.conf':
    path => "${confpath}/puppetproxy.conf",
  }

  file_line {'puppetdashboard.conf':
    path => "${confpath}/puppetdashboard.conf",
  }

  pe_ini_setting {'puppetdb_tlsmode':
    path    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
    section => 'ssl-host',
    setting => 'ssl-protocols',
    value   => $protocol[-1],
  }

}
