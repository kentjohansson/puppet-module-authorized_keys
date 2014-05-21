root_authorized_keys
=============================

**root_authorized_keys** is a Puppet module to populate root's home directory `.ssh/ subdir` with the right `authorized_keys`.

It accepts two parameters:

+ `path` with the path for the file (defaults to `/root/.ssh/authorized_keys`)
+ `keys` with a hash of the keys you want to include
 
The `keys` hash should have the following shape:

```  {'name' => {key => 'ssh-xxx <long_hex_key>'}, ...}```
  
Or with Hiera:
```
  root_authorized_keys::keys:
    'my_key':
      key: 'ssh-dss AAAAB3Nzaasdas...daASsd='
    'another':
      key: 'ssh-rsa ...'
```
Note that the hex_key should only include two fields (the third is only descriptive and can be used as the name of the key)