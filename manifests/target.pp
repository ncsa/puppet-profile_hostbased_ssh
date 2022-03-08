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
# @param sshd_custom_config
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
  Array[ String, 1 ] $sshd_match_nodelist,
  Hash               $sshd_custom_config,
  Array[ String ]    $groups,
  Array[ String ]    $users,
) {

  include ::profile_hostbased_ssh::known_hosts
  include ::profile_hostbased_ssh::shosts_equiv

  ::sshd::allow_from{ 'sshd allow hostbased ssh':
    hostlist                => $sshd_match_nodelist,
    users                   => $users,
    groups                  => $groups,
    additional_match_params => $sshd_custom_config,
  }

}
