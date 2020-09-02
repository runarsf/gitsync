FROM ubuntu:latest

MAINTAINER Runar Fredagsvik "root@runarsf.dev"

USER root

ARG CRON
ENV CRON "${CRON}"

# Cron setup
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install cron curl git openssh-client openssh-server gettext \
 && apt-get clean

# RUN chmod 0744 /etc/cron.d/crontab (cron fails silently if you forget)
COPY crontab /etc/cron.d/crontab
RUN envsubst < "/etc/cron.d/crontab" | tee "/etc/cron.d/crontab"

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Repo setup
# Setup ssh
RUN mkdir /root/.ssh
ADD ssh/id_rsa ssh/id_rsa.pub /root/.ssh/

RUN touch /root/.ssh/known_hosts
# Add gitlab's key
RUN ssh-keyscan "${GIT_HOST}" >> /root/.ssh/known_hosts

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN service ssh restart

RUN eval "$(ssh-agent -s)" && ssh-add -k /root/.ssh/id_rsa

RUN git clone https://github.com/simonthum/git-sync /root/git-sync

CMD git -C /root/repo config --local --bool branch.master.syncNewFiles true \
 && git -C /root/repo config --local --bool branch.master.sync true \
 && git -C /root/repo config --local user.email "${GIT_EMAIL:-}" \
 && git -C /root/repo config --local user.name "${GIT_NAME:-}" \
 && cron && tail -f /var/log/cron.log

# Cron in foreground, requires cron commands to manually redirect to stdout
# > /proc/1/fd/1 2>/proc/1/fd/2
#CMD cron -f
