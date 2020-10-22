FROM circleci/jruby:9.2.13.0-jdk
ENV pip_packages "pipenv ansible pyopenssl"

LABEL maintainer="James R. Griffin III \"jrgriffiniii@gmail.com\""
LABEL repository="https://github.com/pulibrary/dspace-development"

RUN set -eux; \
  sudo apt-get update \
  && sudo apt-get install -y gosu \
  && gosu rm -rf /var/lib/apt/lists/*

RUN gosu apt-get update \
  && gosu apt-get install -y --no-install-recommends \
    acl ant apt-utils build-essential clamav libclamav-dev clamav-daemon cron curl git htop iproute2 \
    libssl-dev net-tools openjdk-11-jdk-headless openssh-server python3-apt python3-setuptools python3-pip \
    silversearcher-ag software-properties-common sudo \
    tmux unzip vim wget zip zlib1g-dev \
  && gosu rm -rf /var/lib/apt/lists/* \
  && gosu rm -Rf /usr/share/doc \
  && gosu rm -Rf /usr/share/man \
  && gosu apt-get clean

RUN localedef --charmap=UTF-8 --inputfile=en_US en_US.UTF-8

# Install Ansible via Pip.
RUN pip3 install -U pip
RUN pip3 install $pip_packages

# Install the Ansible inventory file.
RUN gosu mkdir -p /etc/ansible
COPY guest/opt/ansible/hosts /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

EXPOSE 5432/tcp
EXPOSE 8080/tcp

CMD ["/bin/sh"]
