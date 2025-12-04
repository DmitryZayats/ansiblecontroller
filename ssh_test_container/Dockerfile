FROM rockylinux:8
RUN yum update -y
RUN yum install -y openssh-server
RUN yum install -y procps
RUN yum install -y iproute
RUN yum install -y sudo
RUN yum install -y passwd
RUN sed -i 's/^#PermitRoot/PermitRoot/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
# RUN ssh-keygen -A
# RUN systemctl enable sshd
# COPY id_rsa.pub /root/.ssh/authorized_keys
RUN echo "Very_Secure_Password_123" | passwd root --stdin
RUN useradd ansible_user
RUN echo "Less_Secure_Password_456" | passwd ansible_user --stdin
COPY start.sh /sbin/
CMD [ "/sbin/start.sh" ]
