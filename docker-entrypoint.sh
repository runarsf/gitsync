#!/bin/sh

if test ! -d /root/repo; then
  printf "Initializing empty repository in /root/repo as none could be found, did you remember to mount it? ...\n"
  mkdir -p /root/repo
  git -C /root/repo init
fi

printf "Cron: ${CRON}\n"
printf "Git host: ${GIT_HOST}\n"
printf "Git name: ${GIT_NAME}\n"
printf "Git email: ${GIT_EMAIL}\n"
printf "Git branch: ${GIT_BRANCH}\n"

printf "${CRON} cd /root/repo && /root/git-sync/git-sync >> /var/log/cron.log 2>&1\n# An empty line is required at the end of this file for a valid cron file.\n" \
  > /etc/cron.d/crontab

crontab /etc/cron.d/crontab

eval "$(ssh-agent -s)" && ssh-add -k /root/.ssh/id_rsa
ssh-keyscan "${GIT_HOST}" >> /root/.ssh/known_hosts

#git -C /root/repo branch --set-upstream-to=origin/"${GIT_BRANCH}"
git -C /root/repo config --local --bool branch."${GIT_BRANCH}".syncNewFiles true
git -C /root/repo config --local --bool branch."${GIT_BRANCH}".sync true
git -C /root/repo config --local user.email "${GIT_EMAIL:?}"
git -C /root/repo config --local user.name "${GIT_NAME:?}"

cron
tail -f /var/log/cron.log
