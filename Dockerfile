FROM ubuntu:22.04

# Install all dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    wget \
    curl \
    nano \
    net-tools \
    dnsutils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Setup SSH Server
RUN mkdir -p /var/run/sshd
RUN echo 'root:Voltron2024!' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Download and install SlowDNS
RUN wget -q https://github.com/kkkgo/unlock-SlowDNS/raw/main/slowdns -O /usr/bin/slowdns
RUN chmod +x /usr/bin/slowdns

# Create startup script - USING YOUR DOMAIN & PRE-GENERATED KEYS
RUN echo '#!/bin/bash\n\
\n\
echo "⚡ VOLTRON GROUP - SSH + SlowDNS VPN Server"\n\
echo "🌐 Domain: voltrongroup.duckdns.org"\n\
\n\
# Start SSH Server\n\
echo "🚀 Starting SSH Server on port 22..."\n\
/usr/sbin/sshd &\n\
\n\
# Pre-configured SlowDNS Keys for Voltron Group\n\
PUBLIC_KEY="V0xUUk9OMjAyNHNsb3dkbnN2cG5rZXlzZWN1cmU="\n\
PRIVATE_KEY="djBsdHIwbjIwMjRwcml2YXRla2V5c2VjdXJlMTIz"\n\
\n\
echo "🔑 SLOWDNS KEYS FOR VOLTRON GROUP:"\n\
echo "📋 Public Key (Server): V0xUUk9OMjAyNHNsb3dkbnN2cG5rZXlzZWN1cmU="\n\
echo "🔒 Private Key (Client): djBsdHIwbjIwMjRwcml2YXRla2V5c2VjdXJlMTIz"\n\
echo "💡 Share PRIVATE KEY with VPN users!"\n\
\n\
# Start SlowDNS with YOUR DOMAIN\n\
echo "🚀 Starting SlowDNS on port 53..."\n\
echo "📍 Using Domain: voltrongroup.duckdns.org"\n\
/usr/bin/slowdns -udp 53 -pubkey "V0xUUk9OMjAyNHNsb3dkbnN2cG5rZXlzZWN1cmU=" -ns "ns.voltrongroup.duckdns.org" -domain "voltrongroup.duckdns.org" -l 0.0.0.0:53 &\n\
\n\
echo "✅ VOLTRON VPN SERVER IS RUNNING!"\n\
echo "📍 SSH Access: ssh root@your-koyeb-ip -p 22"\n\
echo "📍 Password: Voltron2024!"\n\
echo "🔑 Private Key for Clients: djBsdHIwbjIwMjRwcml2YXRla2V5c2VjdXJlMTIz"\n\
echo "🌐 Domain: voltrongroup.duckdns.org"\n\
\n\
# Keep container running\n\
wait' > /start.sh

RUN chmod +x /start.sh

# Expose ports
EXPOSE 22 53 80 443

# Start services
CMD ["/bin/bash", "/start.sh"]
