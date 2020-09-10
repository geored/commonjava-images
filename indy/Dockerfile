FROM quay.io/factory2/nos-java-base:latest

ENV INDY_ETC_DIR /usr/share/indy/etc

EXPOSE 8080 8081 8000

USER root

ADD start-indy.py /usr/local/bin/start-indy.py
ADD setup-user.sh /usr/local/bin/setup-user.sh
ADD setup-user.sh /etc/profile.d/setup-user.sh
ADD passwd.template /opt/passwd.template

ARG tarball_url
ARG data_tarball_url

ADD $tarball_url /opt/indy-launcher-skinny.tar.gz
ADD $data_tarball_url /usr/share/indy/indy-launcher-data.tar.gz

ADD .profile /root

RUN mkdir -p /usr/share/indy /usr/share/indy/data/promote/rules && \
    mkdir -p /opt/indy/var/lib/indy/ui /opt/indy/var/log/indy /var/log/indy /etc/indy && \
    mkdir -p /opt/indy/var/lib/indy/data/promote /home/indy && \
    tar -xf /opt/indy-launcher-skinny.tar.gz -C /opt && \
    tar -xf /usr/share/indy/indy-launcher-data.tar.gz -C /usr/share/indy && \
    rm -Rf /opt/indy-launcher-skinny.tar.gz /usr/share/indy/indy-launcher-data.tar.gz /tmp/hsperfdata_root && \
    cp -Rf /usr/share/indy/data/promote/rules /opt/indy/var/lib/indy/data/promote/ && \
    cp -Rf /opt/indy/var/lib/indy/ui /usr/share/indy/ && \
    cp /root/.profile /home/indy && \
    chmod +x /usr/local/bin/* && chmod -R 777 /etc/indy && chmod -R 777 /var/log/indy && \
    chmod -R 777 /usr/share/indy

# https://access.redhat.com/articles/4859371
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/setup-user.sh && /usr/local/bin/start-indy.py"]

RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum update -y --security && \
    yum install -y java-11-openjdk-devel.x86_64 java-11-openjdk-headless.x86_64 dstat gettext && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y nss_wrapper && \
    yum clean all && rm -rf /var/cache/yum /tmp/yum.log /tmp/RPM-GPG-KEY-CentOS-7

ADD lowOverhead.jfc /usr/share/indy/flightrecorder.jfc

# NCL-4814: set umask to 002 so that group permission is 'rwx'
# It works because in start-indy.py we invoke indy.sh with bash -l (login shell)
# that reads from /etc/profile
RUN echo "umask 002" >> /etc/profile

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /etc/indy && \
    chmod -R g=u /etc/indy && \
    chgrp -R 0 /var/log/indy && \
    chmod -R g=u /var/log/indy && \
    chgrp -R 0 /usr/share/indy && \
    chmod -R g=u /usr/share/indy && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy && \
    chmod 644 /etc/profile.d/setup-user.sh

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy
ENV JAVA_OPTS="-Duser.home=${HOME}"
