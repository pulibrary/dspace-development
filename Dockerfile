FROM phusion/baseimage:0.11
ENV pip_packages "pipenv ansible pyopenssl"

LABEL maintainer="James Griffin \"jrgriffiniii@gmail.com\""
LABEL repository="https://github.com/pulibrary/dspace-development"

RUN set -ex; \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  acl ant apt-utils build-essential clamav libclamav-dev clamav-daemon cron curl git htop iproute2 \
  libssl-dev net-tools openjdk-8-jdk-headless openssh-server python3-apt python3-setuptools python3-pip silversearcher-ag software-properties-common sudo \
  tmux unzip vim wget zip zlib1g-dev \
  && apt-get remove -y openjdk-11-jre-headless openjdk-11-jdk-headless \
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc \
  && rm -Rf /usr/share/man \
  && apt-get clean

# Install Ansible via Pip.
RUN pip3 install -U pip
RUN pip3 install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

CMD ["/sbin/my_init"]
