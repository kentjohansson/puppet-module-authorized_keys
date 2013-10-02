# == Class: authorized_keys
#
# Defines ssh-keys for root
#
# Method : concat or ssh_authorized_key

class authorized_keys (
  $keys   = undef,
  $method = "concat",
  $path   = "${::root_home}/.ssh/authorized_keys",
) {

  if $::root_home == undef {
    fail("Root_home is not found, please install stdlib")
  }

  $authkeys = hiera_hash('authorized_keys::keys')

  if $authkeys != undef {
    if $method == "concat" {
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

      create_resources('authorized_keys::concat_key',$authkeys)
    }
    elsif $method == "ssh_authorized_key" {

    create_resources('authorized_keys::key',$authkeys)

    } else {
      fail("Unsuported method: ${method}") 
    }

  }
}

define authorized_keys::key (
  $key,
  $type,
  $options,
) {
  ssh_authorized_key {
    $name :
      user => root,
      type => $type,
      key => $key,
      options => $options,
  }
}

define authorized_keys::concat_key (
  $key,
  $type,
  $options,
) {
  $options_tostring = join($options, ",")
  concat::fragment { $name:
    target  => $authorized_keys::path,
    content => "${options_tostring} ${type} ${key} ${name}\n",
  }
}

