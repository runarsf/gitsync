See exmple use in `docker-compose.yml`

1. Generate ssh keys (no passphrase), or use already existing ssh keys.
  ssh-keygen -t rsa -b 4096 -o -a 100 -f ./ssh/id_rsa -q -N "" -C "gitsync"
2. Add the public key to the deploy keys for your project

# Build image, but start after package installation to save time
# You can set BREAK_CACHE to anything, see next example for an example using random string
docker-compose build --build-arg BREAK_CACHE=yes

# Rebuild and restart entire image excapt package installation
docker-compose down && docker-compose build --build-arg BREAK_CACHE="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)" && docker-compose up -d --force-recreate
