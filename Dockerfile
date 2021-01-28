FROM ubuntu:20.04

ENV PIP_PACKAGES ansible
ENV APT_PACKAGES apt-utils \
    build-essential \
    locales \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    python3-dev \
    python3-setuptools \
    python3-pip \
    python3-yaml \
    software-properties-common \
    rsyslog \
    systemd \
    systemd-cron \
    sudo \
    iproute2

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends $APT_PACKAGES \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && rm -rf /var/cache/apt/
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Fix potential UTF-8 errors with ansible-test.
RUN locale-gen en_US.UTF-8
RUN pip3 install $PIP_PACKAGES

RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
