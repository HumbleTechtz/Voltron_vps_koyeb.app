name: ubuntu-full-os
services:
  - name: ubuntu-os
    image:
      docker:
        image: ubuntu:22.04
    ports:
      - port: 22
        protocol: TCP
      - port: 8000
        protocol: HTTP
    health_checks:
      - type: tcp
        port: 8000
        timeout_seconds: 10RUN echo '#!/bin/bash\n\necho "⚡ VOLTRON VPS - scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🚀 Starting Ubuntu OS..."\n\n# Start health check\npython3 /health_server.py &\n\n# Start SSH\necho "📍 Starting SSH Server..."\n/usr/sbin/sshd -D &\n\nsleep 2\n\necho "✅ ===== SYSTEM READY ====="\necho "🌐 Domain: scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🔑 SSH: root@scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "📝 Password: voltron"\necho "🔧 Port: 22"\necho "💡 Once logged in, install DNSTT/SlowDNS"\necho "======================================"\n\n# Keep running\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]RUN echo '#!/bin/bash\n\necho "⚡ VOLTRON VPS - scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🚀 Starting Ubuntu OS..."\n\n# Start health check\npython3 /health_server.py &\n\n# Start SSH\necho "📍 Starting SSH Server..."\n/usr/sbin/sshd -D &\n\nsleep 2\n\necho "✅ ===== SYSTEM READY ====="\necho "🌐 Domain: scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "🔑 SSH: root@scornful-fern-technology-hub-300d2bd2.koyeb.app"\necho "📝 Password: voltron"\necho "🔧 Port: 22"\necho "💡 Once logged in, install DNSTT/SlowDNS"\necho "======================================"\n\n# Keep running\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]
