# @summary Manage the shosts.equiv file on the target nodes.
#
# Manage the shosts.equiv file on the target nodes. Could be
# used in a standalone fashion (with proper Hiera data) but
# intended to be used indirectly by including the target class.
#
# @example
#   include profile_hostbased_ssh::shosts_equiv
class profile_hostbased_ssh::shosts_equiv (
  String $shosts_equiv_file,
) {

  # ensure proper perms on shosts.equiv file
  file { $shosts_equiv_file :
    ensure  => file,
    content => epp( 'profile_hostbased_ssh/shosts.equiv.epp' ),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }

}
