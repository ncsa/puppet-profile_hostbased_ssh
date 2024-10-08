# @summary Configure a source/client to use hostbased authentication.
#
# Configure a source/client to use hostbased authentication.
#
# Borrows from ncsa/puppet-sshd
#
# @param global_custom_config
#   Additional ssh_conf params (suitable for ssh_config global config...
#   although it will end up in a "Host *" block anyway) 
#
# @param host_match_custom_config
#   Additional ssh_conf params (suitable for ssh_config match block)
#
# @param host_match_pattern
#   Host pattern to match with 'Host' block. Use an empty string if
#   this should be omitted for some reason.
#
# @example
#   include profile_hostbased_ssh::source
class profile_hostbased_ssh::source (
  Hash   $global_custom_config,
  Hash   $host_match_custom_config,
  String $host_match_pattern,
) {
  include profile_hostbased_ssh::known_hosts

  $config_defaults = {
    'ensure' => 'present',
  }

  # add global custom config to ssh_config
  $global_custom_config.each | $key, $val | {
    ssh_config {
      $key :
        value => $val,
        ;
      default:
        * => $config_defaults,
        ;
    }
  }

  if ! empty($host_match_pattern) {
    $config_match_defaults = $config_defaults + { 'host' => $host_match_pattern }

    # add host match block with custom config to ssh_config
    $host_match_custom_config.each | $key, $val | {
      ssh_config {
        $key :
          value => $val,
          ;
        default:
          * => $config_match_defaults,
          ;
      }
    }
  }
}
