# profile_hostbased_ssh

![pdk-validate](https://github.com/ncsa/puppet-profile_hostbased_ssh/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_hostbased_ssh/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure a source (SSH client) or target (SSHD server) to use hostbased authentication


## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Dependencies](#dependencies)
1. [Reference](#reference)


## Description

This puppet profile customizes a host to use hostbased authentication. This can be a source (SSH client host) or a target (SSHD server). Use of the optional pam_slurm_adopt class configures that PAM module (intended for use on a node running slurmd).


## Setup

Include profile_hostbased_ssh in a puppet profile file:

(1) On a source node, e.g., a login node:
```
include ::profile_hostbased_ssh::source
```

(2) On a target node, e.g., a compute node:
```
include ::profile_hostbased_ssh::target
# optionally allow the node to be a source as well, e.g., to allow
# SSH from one compute node to another:
include ::profile_hostbased_ssh::source
# optionally configure use of pam_slurm_adopt (on a node running slurmd):
include ::profile_hostbased_ssh::pam_slurm_adopt
```

## Usage

The following parameters likely need to be set for any deployment:

```yaml
profile_hostbased_ssh::known_hosts::hosts_data:
  name_for_set_of_hosts:
    domain: "domain.for.these.nodes"
    key_type: "ecdsa-sha2-nistp256" # or some other type
    key: "contents of the public key"
    hosts:
      short-hostname-01: "ip.address.of.01"
      short-hostname-02: "ip.address.of.02"

profile_hostbased_ssh::source::host_match_pattern: "match* hosts* like* these* in* ssh_config*"

profile_hostbased_ssh::target::groups:
  - "group_who_should_be_able_to_ssh"
  - ...
# and/or use profile_hostbased_ssh::target::users: ...
profile_hostbased_ssh::target::sshd_match_nodelist:
  - "IP.address.to.allow"
  - "CIDR.block.to.allow/24"
  - ...
```

## Dependencies

NCSA [puppet/sshd](https://github.com/ncsa/puppet-sshd)

[herculesteam/augeasproviders](https://forge.puppet.com/modules/herculesteam/augeasproviders)

[puppetlabs/firewall](https://forge.puppet.com/modules/puppetlabs/firewall)

[MiamiOH/pam_access](https://github.com/MiamiOH/puppet-pam_access)


## Reference

See: [REFERENCE.md](REFERENCE.md)
