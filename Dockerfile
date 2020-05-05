FROM pulibrary/puldocker-ubuntu1804-ansible

LABEL maintainer="James Griffin \"jrgriffiniii@gmail.com\""
LABEL repository="https://github.com/jrgriffiniii/dspace-vagrant"

RUN set -ex; \
  apt-get update; \
  apt-get -y install \
    acl ant build-essential clamav libclamav-dev clamav-daemon curl git htop iproute2 \
    libssl-dev python-apt python-setuptools python3-pip silversearcher-ag tomcat8 \
    tmux unzip vim wget zip zlib1g-dev; \
  rm -rf /var/lib/apt/lists/*

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/sbin/my_init"]
