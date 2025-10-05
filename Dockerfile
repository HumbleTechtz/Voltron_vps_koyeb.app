FROM ubuntu:22.04

# Install SSH
RUN apt-get update && apt-get install -y openssh-server

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Voltron2024!' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create simple web server for health check (port 8000)
RUN apt-get install -y python3
RUN echo '#!/usr/bin/python3\nimport http.server\nimport socketserver\n\nPORT = 8000\n\nclass HealthHandler(http.server.SimpleHTTPRequestHandler):\n    def do_GET(self):\n        self.send_response(200)\n        self.end_headers()\n        self.wfile.write(b"OK")\n\nwith socketserver.TCPServer(("", PORT), HealthHandler) as httpd:\n    print(f"Health check server on port {PORT}")\n    httpd.serve_forever()' > /health_check.py

# Start both SSH and health check
RUN echo '#!/bin/bash\n\
echo "Starting health check server on port 8000..."\n\
python3 /health_check.py &\n\
sleep 2\n\
echo "Starting SSH server on port 22..."\n\
/usr/sbin/sshd -D\n\
wait' > /start.sh

RUN chmod +x /start.sh

EXPOSE 22 8000
CMD ["/bin/bash", "/start.sh"]
