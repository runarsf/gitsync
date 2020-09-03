FROM ubuntu:latest

MAINTAINER Runar Fredagsvik "root@runarsf.dev"

USER root

#ARG CRON
ENV CRON "${CRON}"
#ARG GIT_HOST
ENV GIT_HOST "${GIT_HOST}"
#ARG GIT_EMAIL
ENV GIT_EMAIL "${GIT_EMAIL}"
#ARG GIT_NAME
ENV GIT_NAME "${GIT_NAME}"
#ARG GIT_BRANCH
ENV GIT_BRANCH "${GIT_BRANCH}"

# Cron setup
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install cron curl git openssh-client openssh-server gettext \
 && apt-get clean

# RUN chmod 0744 /etc/cron.d/crontab (cron fails silently if you forget)
# Could write directly to file instead of copy, would remove the need for envsubst and gettext
#COPY crontab /etc/cron.d/crontab
#RUN envsubst < "/etc/cron.d/crontab" | tee "/etc/cron.d/crontab"
RUN mkdir -p /etc/cron.d \
 && touch /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/crontab

# Apply cron job
#RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN git clone https://github.com/simonthum/git-sync /root/git-sync

RUN mkdir -p /root/.ssh
#ADD ssh/id_rsa ssh/id_rsa.pub /root/.ssh/

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && service ssh restart

RUN touch /root/.ssh/known_hosts

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Has to be in command, since /root/repo isn't mounted during build
#CMD git -C /root/repo config --local --bool branch."${GIT_BRANCH}".syncNewFiles true \
# && git -C /root/repo config --local --bool branch."${GIT_BRANCH}".sync true \
# && git -C /root/repo config --local user.email "${GIT_EMAIL:-}" \
# && git -C /root/repo config --local user.name "${GIT_NAME:-}" \
# && cron && tail -f /var/log/cron.log

# Cron in foreground, requires cron commands to manually redirect to stdout
# > /proc/1/fd/1 2>/proc/1/fd/2
#CMD cron -f
