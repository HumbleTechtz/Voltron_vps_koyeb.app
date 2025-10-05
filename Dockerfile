FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Voltron2024!' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Download SlowDNS - SIMPLE METHOD
RUN wget -O /usr/bin/slowdns https://github.com/kkkgo/unlock-SlowDNS/raw/main/slowdns
RUN chmod +x /usr/bin/slowdns

# Create simple startup script
RUN echo '#!/bin/bash\n\
echo "🔧 Starting SSH Server..."\n\
/usr/sbin/sshd -D &\n\
echo "✅ SSH Server Running on port 22"\n\
echo "🔑 SSH: root@[IP] Password: Voltron2024!"\n\
wait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22
CMD ["/bin/bash", "/start.sh"]
