# == Class: authorized_keys
#
# Defines ssh-keys for root
#
class root_authorized_keys (
  $keys = undef,
  $path = "${::root_home}/.ssh/authorized_keys",
) {

  if $::root_home == undef {
    fail("Root_home is not found, please install stdlib")
  }

  if $keys != undef {

    include concat::setup

    file { 'ssh-folder':
      path   => "${::root_home}/.ssh",
      ensure => "directory",
    }

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

    create_resources('root_authorized_keys::key',$keys)
  }
}

define root_authorized_keys::key (
  $key,
) {

  concat::fragment { $name:
    target  => ${root_authorized_keys::path},
    content => "${key} ${name}\n",
  }
}
