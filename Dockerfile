FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update system (lightweight)
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    net-tools \
    iproute2

# Setup SSH only
RUN mkdir -p /var/run/sshd
RUN echo 'root:ubuntu' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Health check (lightweight)
RUN echo '#!/bin/bash\nwhile true; do echo "OK" | nc -l -p 8000 -q 1; done' > /health.sh
RUN chmod +x /health.sh

# Startup script
RUN echo '#!/bin/bash\n\
echo "🚀 Ubuntu SSH Server - Free Plan"\n\
/usr/sbin/sshd -D &\n\
/bin/bash /health.sh &\n\
echo "✅ Ready! SSH: root@[IP] Password: ubuntu"\n\
wait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000
CMD ["/bin/bash", "/start.sh"]
