# molecule-ubuntu2004 Ansible Test Image

[![CI](https://github.com/bilalcaliskan/molecule-ubuntu2004/workflows/Build/badge.svg?branch=master&event=push)](https://github.com/bilalcaliskan/molecule-ubuntu2004/actions?query=workflow%3ABuild)
[![Docker pulls](https://img.shields.io/docker/pulls/bilalcaliskan/molecule-ubuntu2004)](https://hub.docker.com/r/bilalcaliskan/molecule-ubuntu2004/)

Ubuntu 18.04 Docker container for Ansible playbook and role testing.

## How to Use
- [Install Docker](https://docs.docker.com/engine/installation/).
- Pull this image from Docker Hub:
  - `docker pull bilalcaliskan/molecule-ubuntu2004:latest`
- Run a container from the image:
  - `docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro bilalcaliskan/molecule-ubuntu2004:latest`
- Use Ansible inside the container:
  - `docker exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check`
