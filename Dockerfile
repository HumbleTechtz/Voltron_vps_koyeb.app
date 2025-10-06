FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install Ubuntu full system
RUN apt-get update && apt-get upgrade -y

# Install essential packages
RUN apt-get install -y \
    sudo \
    curl \
    wget \
    gnupg \
    software-properties-common \
    systemd \
    openssh-server \
    net-tools \
    iproute2 \
    dnsutils \
    vim \
    nano \
    python3 \
    git \
    build-essential

# Setup SSH for domain access
RUN mkdir -p /var/run/sshd
RUN echo 'root:voltron' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Create health check for Koyeb
RUN echo '#!/usr/bin/python3\nimport socket\nimport time\n\nserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nserver.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)\nserver.bind(("0.0.0.0", 8000))\nserver.listen(5)\nprint("✅ Health check running on port 8000")\nwhile True:\n    conn, addr = server.accept()\n    conn.send(b"HTTP/1.1 200 OK\\r\\n\\r\\nOK")\n    conn.close()' > /health_server.py

# Startup script for your domain
RUN echo '#!/bin/bash\n\necho "⚡ VOLTRON VPS - scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🚀 Starting Ubuntu OS..."\n\n# Start health check\npython3 /health_server.py &\n\n# Start SSH\necho "📍 Starting SSH Server..."\n/usr/sbin/sshd -D &\n\nsleep 2\n\necho "✅ ===== SYSTEM READY ====="\necho "🌐 Domain: scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🔑 SSH: root@scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "📝 Password: voltron"\necho "🔧 Port: 22"\necho "💡 Once logged in, install DNSTT/SlowDNS"\necho "======================================"\n\n# Keep running\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]RUN echo '#!/bin/bash\n\necho "⚡ VOLTRON VPS - scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🚀 Starting Ubuntu OS..."\n\n# Start health check\npython3 /health_server.py &\n\n# Start SSH\necho "📍 Starting SSH Server..."\n/usr/sbin/sshd -D &\n\nsleep 2\n\necho "✅ ===== SYSTEM READY ====="\necho "🌐 Domain: scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🔑 SSH: root@scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "📝 Password: voltron"\necho "🔧 Port: 22"\necho "💡 Once logged in, install DNSTT/SlowDNS"\necho "======================================"\n\n# Keep running\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]
