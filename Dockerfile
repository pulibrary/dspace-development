FROM circleci/jruby:9.2.13.0-jdk
ENV pip_packages "pipenv==2020.8.13 ansible==2.10.1 pyopenssl==19.1.0"

LABEL maintainer="James R. Griffin III \"jrgriffiniii@gmail.com\""
LABEL repository="https://github.com/pulibrary/dspace-development"

# hadolint ignore=DL3004
RUN set -eux; \
  sudo apt-get update \
  && sudo apt-get install -y gosu \
  && sudo rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3004
RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
    acl ant apt-utils build-essential clamav libclamav-dev clamav-daemon cron curl git htop iproute2 \
    libssl-dev net-tools openjdk-11-jdk-headless openssh-server python3-apt python3-setuptools python3-pip \
    silversearcher-ag software-properties-common sudo \
    tmux unzip vim wget zip zlib1g-dev \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo rm -Rf /usr/share/doc \
  && sudo rm -Rf /usr/share/man \
  && sudo apt-get clean

# hadolint ignore=DL3004
RUN sudo localedef --charmap=UTF-8 --inputfile=en_US en_US.UTF-8

# Install Ansible via Pip.
RUN pip3 install -U pip==20.2.4
RUN pip3 install pipenv==2020.8.13 ansible==2.10.1 pyopenssl==19.1.0

# Install the Ansible inventory file.
# hadolint ignore=DL3004
RUN sudo mkdir -p /etc/ansible
COPY guest/opt/ansible/hosts /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

EXPOSE 5432/tcp
EXPOSE 8080/tcp

CMD ["/bin/sh"]
