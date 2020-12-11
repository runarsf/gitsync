# gitsync

Automatically sync a git repository using docker.

## Getting started
See exmple use in [docker-compose.yml](./docker-compose.yml), replace `image` with newest version in [runarsf/gitsync/packages](https://github.com/runarsf/gitsync/packages) (`docker.pkg.github.com/runarsf/gitsync/gitsync:1.0.2`), and remove `build`.\
Required environment variables are `GIT_NAME` and `GIT_EMAIL`, either set these in `.env` or directly in `docker-compose.yml`.\
NB! Remember to properly configure `.gitignore`, git-sync will automatically push *all* changes, so ignoring your ssh-key could be a good idea.

1. Generate ssh keys (no passphrase), or use already existing ssh keys.\
  `ssh-keygen -t rsa -b 4096 -o -a 100 -f ./id_rsa -q -N "" -C "gitsync"`
2. Add the public key (`id_rsa.pub`) to the deploy keys for your project, remember to allow write access.

### Permission errors?

Run these commands from the _root_ of the repository.\
<ins>**Don't**</ins> add `user: "1000:1000"` to `docker-compose.yml`.

```bash
find .git -type d | xargs sudo chmod 755
find .git/objects -type f | xargs sudo chmod 444
find .git -type f | grep -v /objects/ | xargs sudo chmod 644
```

Reading materials for Docker and docker-compose file permissions:

- [What file permissions should the contents of $GIT_DIR have?](https://stackoverflow.com/a/3648777)
- [docker-file-permissions](https://github.com/bahmutov/docker-file-permissions)
- [Docker compose volume Permissions linux](https://stackoverflow.com/a/52952309/6914274)
- [Add a volume to Docker, but exclude a sub-folder](https://stackoverflow.com/a/37898591/6914274)

### TODO:

- [ ] Add support for password protected ssh keys
- [ ] Investigate file permissions
