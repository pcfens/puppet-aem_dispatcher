class aem_dispatcher::params {
  $install_from             = 'remote_archive'
  $archive_url              = undef
  $package_name             = 'dispatcher-apache2.4-linux-x86'
  $ensure_package           = 'present'
  $manage_dispatcher_config = true
  $config_file              = '/etc/apache2/dispatcher.any'
  $log_file                 = '/var/log/dispatcher.log'
  $log_level                = 'warn'
  $no_server_header         = 'Off'
  $decline_root             = 'Off'
  $use_processed_url        = 'Off'
  $pass_error               = 0
}
