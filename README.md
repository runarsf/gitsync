# Generate ssh keys (no passphrase)
ssh-keygen -t rsa -b 4096 -o -a 100 -f ./ssh/id_rsa -q -N "" -C "gitsync"

# Add this key to the deploy keys for your project

# Build image, but start after package installation to save time
docker-compose build --build-arg BREAK_CACHE=yes
