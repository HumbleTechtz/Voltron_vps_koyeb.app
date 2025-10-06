FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update system kamili
RUN apt-get update && apt-get upgrade -y

# Install Ubuntu desktop environment (optional)
RUN apt-get install -y \
    ubuntu-server \
    ubuntu-standard \
    systemd \
    systemd-sysv \
    dbus \
    sudo \
    curl \
    wget \
    gnupg \
    software-properties-common \
    net-tools \
    iproute2 \
    dnsutils \
    htop \
    nano \
    vim \
    git \
    build-essential \
    python3 \
    python3-pip

# Create user kama Ubuntu halisi
RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu

# Setup SSH kwa Ubuntu OS
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:ubuntu' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Setup Ubuntu services
RUN systemctl enable ssh

# Create Ubuntu startup script
RUN echo '#!/bin/bash\n\
echo "=========================================="\n\
echo "🖥️  UBUNTU 22.04 LTS - FULL OS"\n\
echo "=========================================="\n\
echo "🚀 Booting Ubuntu System..."\n\
\n\
# Start system services\n\
echo "📍 Starting system services..."\n\
\n\
# Start SSH server\n\
/usr/sbin/sshd -D &\n\
\n\
# Health check for Koyeb\n\
while true; do\n\
    echo "HTTP/1.1 200 OK\\r\\n\\r\\nUbuntu OK" | nc -l -p 8000 -q 1\n\
done &\n\
\n\
echo "✅ UBUNTU OS READY!"\n\
echo "🔑 SSH Access: root@scornful-fern-technology-hub-300d2bd2.koyeb.app"\n\
echo "📝 Password: ubuntu"\n\
echo "🔧 Port: 22"\n\
echo "💻 Full Ubuntu environment activated"\n\
echo "=========================================="\n\
\n\
# Keep Ubuntu running\n\
wait' > /ubuntu-start.sh

RUN chmod +x /ubuntu-start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/ubuntu-start.sh"]
