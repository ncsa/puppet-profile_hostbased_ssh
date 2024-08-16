# @summary Manage /etc/ssh/ssh_known_hosts for both source and target nodes in a hostbased authentication scenario.
#
# Manage /etc/ssh/ssh_known_hosts for both source and target nodes in a hostbased authentication scenario.
#
# Param data for this class is also used to built shosts.equiv for the target class.
#
# This class is used by the target and source classes, but could also be used in a standalone fashion.
#
# @param hosts_data
#   Hash of the form:
#     <name_for_host_set_1>:
#       domain: "ncsa.illinois.edu"
#       key_type: "ecdsa-sha2-nistp256" # suitable for ssh_known_hosts
#       key: "content of public key that identifies hosts in this set"
#       hosts: # host-IP pairs
#         login1: 141.142.X.Y
#         login2: 141.142.X.Z
#     <name_for_host_set_2>:
#       domain: ...
#       key_type: ...
#       key: "..."
#       hosts:
#         ...
#     ...
#
# @param ssh_known_hosts_file
#   Location of the ssh_known_hosts file (usually /etc/ssh/ssh_known_hosts).
#
class profile_hostbased_ssh::known_hosts (
  Hash   $hosts_data,
  String $ssh_known_hosts_file,
) {
  # ensure proper perms on known hosts file
  file { $ssh_known_hosts_file :
    ensure => file,
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
  }

  # create sets of entries in /etc/ssh/ssh_known_hosts from each host set
  $hosts_data.each | $host_set, $data | {
    $domain   = $data[domain]
    $key_type = $data[key_type]
    $key      = $data[key]
    $hosts    = $data[hosts]
    # create individual sshkey resources from each host
    $hosts.each | $host, $ip| {
      $fqdn    = "${host}.${domain}"
      $aliases = [$fqdn, $ip]
      sshkey { $host :
        ensure       => present,
        host_aliases => $aliases,
        key          => $key,
        target       => $ssh_known_hosts_file,
        type         => $key_type,
      }
    }
  }
}
