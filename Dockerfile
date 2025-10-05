FROM ubuntu:22.04

# Update and install SSH only
RUN apt-get update && apt-get install -y openssh-server

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Voltron2024!' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH
CMD ["/usr/sbin/sshd", "-D"]
