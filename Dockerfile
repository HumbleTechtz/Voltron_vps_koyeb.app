FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update system
RUN apt-get update && apt-get upgrade -y

# Install basic system tools
RUN apt-get install -y \
    sudo \
    curl \
    wget \
    net-tools \
    iproute2 \
    dnsutils \
    openssh-server

# Setup SSH
RUN mkdir -p /var/run/sshd
RUN echo 'root:ubuntu' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Create health check
RUN echo '#!/bin/bash\nwhile true; do echo -e "HTTP/1.1 200 OK\\n\\nOK" | nc -l -p 8000 -q 1; done' > /health.sh
RUN chmod +x /health.sh

# Startup script
RUN echo '#!/bin/bash\n\necho "Ubuntu OS Starting..."\n/usr/sbin/sshd -D &\n/bin/bash /health.sh &\necho "Ready! SSH: root@[IP] Password: ubuntu"\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]
