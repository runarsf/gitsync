# Generate ssh keys (no passphrase)
ssh-keygen -t rsa -b 4096 -o -a 100 -C "gitsync"

# Build image, but start after package installation to save time
docker-compose build --build-arg BREAK_CACHE=yes
