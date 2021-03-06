# Internal
#
# Installs the package
#
class pptp::install {
  if $pptp::package_manage {
    if 'Suse' == $facts['os']['family'] {
      package { 'pptp':
        ensure          => $pptp::package_ensure,
        provider        => 'rpm',
        source          => 'http://download.opensuse.org/repositories/home:/gallochri/SLE_15/x86_64/pptp-1.10.0-3.1.x86_64.rpm',
        install_options => '--force', # this package will replace `/etc/ppp`
      }
    } else {
      package { $pptp::package_name:
        ensure => $pptp::package_ensure,
      }
    }

    file { '/sbin/pon':
      ensure   => 'file',
      owner    => 'root',
      group    => 'root',
      mode     => '0755',
      seluser  => 'system_u',
      selrole  => 'object_r',
      seltype  => 'usr_t',
      selrange => 's0',
      content  => template('pptp/pon.erb'),
    }

    file { '/sbin/poff':
      ensure   => 'file',
      owner    => 'root',
      group    => 'root',
      mode     => '0755',
      seluser  => 'system_u',
      selrole  => 'object_r',
      seltype  => 'usr_t',
      selrange => 's0',
      content  => template('pptp/poff.erb'),
    }
  }

  $options_array = lookup(
    'pptp::options',
    Array[String],
    'unique',
    []
  )

  file { $pptp::options_file:
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    seluser  => 'system_u',
    selrole  => 'object_r',
    seltype  => 'usr_t',
    selrange => 's0',
    content  => epp('pptp/options.epp', {
      options => $pptp::install::options_array,
    }),
  }

  if $pptp::module_manage {
    include ::kmod

    # HACK para carregar o modulo no SLES 12
    if 'Suse' == $facts['os']['family'] {
      file { '/etc/sysconfig/kernel':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'MODULES_LOADED_ON_BOOT=ppp_mppe',
        before  => [
          Kmod::Load['ppp_mppe'],
        ],
      }
    }

    kmod::load { 'ppp_mppe': }
  }

  if $pptp::firewall_manage {
    include ::firewalld
    firewalld_direct_rule { 'Accept gre protocol':
      ensure        => present,
      inet_protocol => 'ipv4',
      table         => 'filter',
      chain         => 'INPUT',
      priority      => 0,
      args          => '-p gre -j ACCEPT',
    }
  }
}
