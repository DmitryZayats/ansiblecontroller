FROM rockylinux:8

ARG ANSIBLE_CORE_VERSION
ARG ANSIBLE_LINT
ENV ANSIBLE_LINT ${ANSIBLE_LINT}
ENV ANSIBLE_CORE ${ANSIBLE_CORE_VERSION}

# Labels.
LABEL maintainer="Dmitry Zayats" \
      version="12-03-2025" \
      build-date="12-03-2025" \
      description="Ansible inside Docker" \
      url="https://github.com/DmitryZayats/ansiblecontroller"

RUN dnf -y update
RUN dnf -y install epel-release
RUN dnf -y install initscripts sudo
RUN dnf -y install python3-pip git
RUN pip3 install --upgrade pip
RUN pip install ansible pandas openpyxl xlsxwriter && \
    pip install pywinrm mitogen==0.2.10 ansible-lint jmespath && \
    pip install pysocks && \
    dnf -y install sshpass openssh-clients && \
    dnf -y install nmap-ncat && \
    dnf -y install net-tools && \
    dnf -y install iproute && \
    dnf -y install cronie.x86_64 && \
    dnf -y install java-1.8.0-openjdk.x86_64 && \
    dnf -y install libxslt && \
    dnf -y remove epel-release && \
    dnf clean all && \
    rm -rf /root/.cache/pip
RUN pip install six
RUN pip install schedule
RUN pip install pexpect

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

RUN mkdir /root/.ssh

WORKDIR /ansible

CMD [ "/sbin/crond", "-in" ]
