# @summary Implement use of the pam_slurm_adopt module.
#
# Implement use of the pam_slurm_adopt module.
#
# This module should be included on 'target' hosts that run slurmd.
#
# Includes masking systemd-logind and removing pam_systemd from
# the PAM stack:
#   https://bugs.schedmd.com/show_bug.cgi?id=3912
#   https://bugs.schedmd.com/show_bug.cgi?id=5920
#
# @param pam_configs
#   Hash of data to pass to augeasproviders_pam.
#
# @param services_to_mask
#   Array of services to stop and mask
#
# @example
#   include profile_hostbased_ssh::pam_slurm_adopt
class profile_hostbased_ssh::pam_slurm_adopt (
  Array $services_to_mask,
  Hash  $pam_config,
) {
  # MASK CONFLICTING SERVICES
  $services_to_mask.each | $service | {
    service { $service :
#        enable => mask,
      ensure => stopped,
      notify => Exec["mask_${service}"],
    }
    ## due to some bug, we can't mask the .service w/ the Puppet service resource
    ## so we'll do it with an exec
    exec { "mask_${service}":
      command     => "/usr/bin/systemctl mask ${service}",
      refreshonly => true,
    }
  }

  # CONFIGURE PAM STACK (BORROWED FROM LSST: stdcfg::access)
  each($pam_config) |String[1] $key, Hash $value| {
    pam { $key:
      * => $value,
    }
  }
}
