See exmple use in `docker-compose.yml`

1. Generate ssh keys (no passphrase), or use already existing ssh keys.
  ssh-keygen -t rsa -b 4096 -o -a 100 -f ./ssh/id_rsa -q -N "" -C "gitsync"
2. Add the public key to the deploy keys for your project

# Build image, but start after package installation to save time
docker-compose build --build-arg BREAK_CACHE=yes
