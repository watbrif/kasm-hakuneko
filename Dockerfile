FROM kasmweb/ubuntu-focal-desktop:1.13.0

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl libxss1 libappindicator1 libindicator7 wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Clone and install HakuNeko
RUN git clone https://github.com/manga-download/hakuneko.git /opt/hakuneko && \
    cd /opt/hakuneko && \
    ./scripts/setup.sh && \
    npm install && npm run build

# Set permissions
RUN chmod -R 755 /opt/hakuneko

# Configure startup script
COPY start-hakuneko.sh /usr/local/bin/start-hakuneko.sh
RUN chmod +x /usr/local/bin/start-hakuneko.sh

# Expose ports for kasmVNC
EXPOSE 6901

# Set default command to start kasmVNC and HakuNeko
CMD ["/usr/local/bin/start-hakuneko.sh"]
