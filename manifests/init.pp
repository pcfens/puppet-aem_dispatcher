class aem_dispatcher (
  $version,
  $install_from             = $aem_dispatcher::params::install_from,
  $archive_url              = $aem_dispatcher::params::archive_url,
  $package_name             = $aem_dispatcher::params::package_name,
  $ensure_package           = $aem_dispatcher::params::ensure_package,
  $manage_dispatcher_config = $aem_dispatcher::params::manage_dispatcher_config,
  $config_file              = $aem_dispatcher::params::config_file,
  $log_file                 = $aem_dispatcher::params::log_file,
  $log_level                = $aem_dispatcher::params::log_level,
  $decline_root             = $aem_dispatcher::params::decline_root,
  $no_server_header         = $aem_dispatcher::params::no_server_header,
  $use_processed_url        = $aem_dispatcher::params::use_processed_url,
  $pass_error               = $aem_dispatcher::params::pass_error,
) inherits aem_dispatcher::params {
  validate_string($config_file, $log_file)

  if $install_from == 'remote_archive' and $archive_url == undef {
    fail('An archive URL must be specified to install the dispatcher module')
  } elsif $install_from == 'remote_archive' {
    validate_re($archive_url, '\.tar\.gz$', 'archive_url must point to a gzipped tarball')
  }

  anchor { 'aem_dispatcher::begin': } ->
  class { '::aem_dispatcher::module': } ->
  anchor { 'aem_dispatcher::end': }
}
