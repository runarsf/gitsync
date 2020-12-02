# gitsync

Automatically sync a git repository using docker.

## Getting started
See exmple use in [docker-compose.yml](./docker-compose.yml), replace `image` with newest version in [runarsf/gitsync/packages](https://github.com/runarsf/gitsync/packages) (`docker.pkg.github.com/runarsf/gitsync/gitsync:1.0.2`), and remove `build`.\
You can modify environment variables in the `.env` file or directly in `docker-compose.yml`.\
NB! Remember to properly configure `.gitignore`, git-sync will automatically push *all* changes, so ignoring your ssh-key could be a good idea.

1. Generate ssh keys (no passphrase), or use already existing ssh keys.\
  `ssh-keygen -t rsa -b 4096 -o -a 100 -f ./id_rsa -q -N "" -C "gitsync"`
2. Add the public key (`id_rsa.pub`) to the deploy keys for your project, remember to allow write access.

### TODO:

- [ ] Add support for password protected ssh keys
