# == Class: authorized_keys
#
# Adds or deletes one or more ssh-keys
#
class authorized_keys (
  $keystore = "/root/.ssh/authorized_keys",
) {
  include concat::setup
  concat { $keystore:
    owner => root,
    group => root,
    mode  => '0600',
  }
  concat::fragment { "header":
    target  => $keystore,
    content => "# This file is being maintained by Puppet.\n# DO NOT EDIT\n",
    order   => 01,
  }
  $authkeys = hiera_hash('authorized_keys::keys', undef)
  if $authkeys != undef {
        create_resources('authorized_keys::key',$authkeys)
  }
}

define authorized_keys::key (
  $key,
) {
  concat::fragment { "${name}":
    target  => $authorized_keys::keystore,
    content => "${key}\n",
  }
}
