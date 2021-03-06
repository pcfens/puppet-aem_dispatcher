class aem_dispatcher::module inherits aem_dispatcher {
  case $aem_dispatcher::install_from {
    'package': {
      package { $::aem_dispatcher::package_name:
        ensure => $::aem_dispatcher::ensure_package,
        before => Apache::Mod['dispatcher'],

      }
    }
    'remote_archive': {
      if !defined(Package['curl']){
        package { 'curl':
          ensure => present,
        }
      }

      if $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {
        $lib_path = '/usr/lib64/httpd/modules/'
      } else {
        $lib_path = $::apache::params::lib_path
      }

      exec { 'install-dispatcher':
        path    => '/usr/bin:/bin:/sbin',
        cwd     => $lib_path,
        command => "curl ${aem_dispatcher::archive_url} | tar xvz --wildcards dispatcher-apache*.so",
        creates => "${lib_path}/dispatcher-apache${::apache::apache_version}-${::aem_dispatcher::version}.so",
        require => [Package['curl'], Class['apache'] ],
      }

      file { 'dispatcher_module.so':
        path    => "${lib_path}/dispatcher-apache${::apache::apache_version}-${::aem_dispatcher::version}.so",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Exec['install-dispatcher'],
        notify  => Service['httpd'],
      }
    }
    default: {
      info('AEM dispatcher will not be installed by puppet')
    }
  }

  file { 'dispatcher.conf':
    path    => "${::apache::mod_dir}/dispatcher.conf",
    content => template("${module_name}/dispatcher.config.erb"),
    notify  => Service['httpd'],
  }

  if $aem_dispatcher::manage_dispatcher_config {
    file { 'dispatcher.any':
      path    => $aem_dispatcher::config_file,
      content => template("${module_name}/dispatcher.any.erb"),
      mode    => '0644',
      require => Class['apache'],
      notify  => Service['httpd'],
    }
  }

  ::apache::mod { 'dispatcher':
    id   => 'dispatcher_module',
    path => "${::apache::params::lib_path}/dispatcher-apache${::apache::apache_version}-${::aem_dispatcher::version}.so",
  }


}
