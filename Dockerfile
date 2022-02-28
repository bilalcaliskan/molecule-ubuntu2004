FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3-setuptools \
       python3-pip \
       python3-wheel \
       python3-dev \
       build-essential libssl-dev libffi-dev \
       systemd \
       rsyslog \
       sudo \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
RUN pip3 install --upgrade pip && pip3 install ansible==2.9.16

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
RUN mkdir -p /etc/ansible /usr/share/man/man1
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN echo "[defaults]\ninterpreter_python=/usr/bin/python3" > /etc/ansible/ansible.cfg
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
