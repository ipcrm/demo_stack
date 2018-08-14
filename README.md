Demo Stack
==========
WIP

Setup
=====
Outside of installing terraform and running `terraform init` before use:

* Create a symlink in the `pem` directory via `ln -s <path to your ec2 pem file> pem/id_rsa`.

This key is used for remote exec's (like purging nodes after descruction)

State
=====
Currently creates(at varies states of configuration):

- vpc/subnets
- sg
- puppet master
- cd4pe host
- lnx nodes
- win nodes


