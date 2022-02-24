FROM ubuntu:20.04

LABEL maintainer="bilalcaliskan"
ENV DEBIAN_FRONTEND noninteractive
ENV PIP_PACKAGES pip ansible==2.9.16 pyopenssl
ENV APT_PACKAGES wget apt-utils build-essential locales zlib1g-dev \
    libffi-dev libssl-dev libyaml-dev software-properties-common \
    rsyslog systemd systemd-cron sudo iproute2


RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends $APT_PACKAGES \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && rm -rf /var/cache/apt/

WORKDIR /opt
RUN wget https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz \
    && tar -xf Python-3.9.10.tgz
WORKDIR /opt/Python-3.9.10
RUN ./configure --enable-optimizations
RUN make altinstall
RUN apt-get remove -y python3 \
    && apt-get autoremove -y
RUN ln -s /usr/local/bin/python3.9 /usr/bin/python3

WORKDIR /root
RUN locale-gen en_US.UTF-8
RUN python3 -m pip install --upgrade $PIP_PACKAGES
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN mkdir -p /usr/share/man/man1 /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
# Remove unnecessary getty and udev targets that result in high CPU usage when using 
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
