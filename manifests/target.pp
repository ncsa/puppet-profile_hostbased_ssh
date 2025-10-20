# @summary Configure a target/server to accept hostbased authentication.
#
# Configure a target/server to accept hostbased authentication.
#
# Heavily based on profile_allow_ssh_from_bastion. Also borrows from
# LSST: stdcfg::access
#
# @param groups
#   One or more LDAP / UNIX groups that are allowed to login from
#   any of the nodes in sshd_match_nodelist.
#
#   Note: This is set to [] by default, but one of `groups` or
#         `users` must be set.
#
# @param sshd_match_config
#   Additional sshd_conf params (suitable for sshd_config match block)
#
# @param sshd_match_nodelist
#   List of hostnames / IPs / CIDRs from which to accept hostbased authentication.
#
#   Note: must contain at least 1 item
#
# @param users
#   One or more LDAP / UNIX users that are allowed to login from
#   any of the nodes in sshd_match_nodelist.
#
#   Note: This is set to [] by default, but one of `groups` or
#         `users` must be set.
#
# @example
#   include profile_hostbased_ssh::target
class profile_hostbased_ssh::target (
  Array[String, 1]     $sshd_match_nodelist,
  Hash[String, String] $sshd_match_config,
  Hash[String, String] $sshd_global_config,
  Array[String]        $groups,
  Array[String]        $users,
  Boolean              $sshd_allow_ips = $sshd_global_config['UseDNS'] != 'yes',
) {
  include profile_hostbased_ssh::known_hosts
  include profile_hostbased_ssh::shosts_equiv

  $sshd_global_config.each | $key, $val | {
    sshd_config {
      $key:
        ensure => present,
        value  => $val;
    }
  }

  if 'root' in $users {
    include profile_hostbased_ssh::root_shosts
    $_sshd_match_config = $sshd_match_config + {
      'IgnoreRhosts' => 'no',
    }
  } else {
    $_sshd_match_config = $sshd_match_config
  }

  ::sshd::allow_from { 'sshd allow hostbased ssh':
    hostlist                => $sshd_match_nodelist,
    users                   => $users,
    groups                  => $groups,
    additional_match_params => $_sshd_match_config,
  }
}
