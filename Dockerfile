FROM ubuntu:22.04

# Install SSH + Python for health check
RUN apt-get update && apt-get install -y openssh-server python3

# Setup SSH
RUN mkdir -p /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN ssh-keygen -A

# Create health check server on port 8000
RUN echo '#!/usr/bin/python3\nimport socket\nimport time\n\nserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)\nserver.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)\nserver.bind(("0.0.0.0", 8000))\nserver.listen(1)\nprint("Health check server running on port 8000")\nwhile True:\n    conn, addr = server.accept()\n    conn.send(b"OK")\n    conn.close()' > /health_server.py

# Startup script
RUN echo '#!/bin/bash\n\necho "Starting health check server on port 8000..."\npython3 /health_server.py &\n\nsleep 2\n\necho "Starting SSH server on port 22..."\n/usr/sbin/sshd -D &\n\necho "✅ Both services running!"\necho "📍 SSH: port 22 (user: root, password: password)"\necho "📍 Health: port 8000"\n\nwait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000

CMD ["/bin/bash", "/start.sh"]
