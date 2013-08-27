# == Class: authorized_keys
#
# Defines ssh-keys for root
#
class authorized_keys (
  $keys = undef,
  $path = "/root/.ssh/authorized_keys",
) {

  if $keys != undef {

    include concat::setup

    concat { $path:
      owner => root,
      group => root,
      mode  => '0600',
    }

    concat::fragment { "header":
      target  => $path,
      content => "# This file is being maintained by Puppet.\n# DO NOT EDIT\n",
      order   => 01,
    }

    create_resources('authorized_keys::key',$keys)
  }
}

define authorized_keys::key (
  $key,
) {

  concat::fragment { $name:
    target  => $authorized_keys::path,
    content => "${key} ${name}\n",
  }
}
