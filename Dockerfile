FROM kasmweb/core-ubuntu-focal:develop

# Ensure running as root
USER root

# Install dependencies
RUN mkdir -p /var/lib/apt/lists/partial && chmod 755 /var/lib/apt/lists/partial && \
 apt-get update && \
 apt-get install -y \
        dbus \
        jq \
        python \
        wget \
        zenity \
        git \
        curl \
        libxss1 \
        libappindicator1 \
        libindicator7 \
        wget \
        unzip \
        npm \
	libxss1 && \
 echo "**** install hakuneko ****" && \
 if [ -z ${HAKUNEKO_RELEASE+x} ]; then \
        HAKUNEKO_RELEASE=$(curl -sX GET "https://api.github.com/repos/manga-download/hakuneko/releases/latest" \
        | jq -r .tag_name); \
 fi && \
 HAKUNEKO_VERSION="$(echo ${HAKUNEKO_RELEASE} | cut -c2-)" && \
 HAKUNEKO_URL="https://github.com/manga-download/hakuneko/releases/download/v${HAKUNEKO_VERSION}/hakuneko-desktop_${HAKUNEKO_VERSION}_linux_amd64.deb" && \
 echo "${HAKUNEKO_VERSION} ;; ${HAKUNEKO_URL}" && \
 curl -o /tmp/hakuneko.deb \
      -L "${HAKUNEKO_URL}" && \
 dpkg -i /tmp/hakuneko.deb && \
 dbus-uuidgen > /etc/machine-id && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# Configure startup script
COPY start-hakuneko.sh /usr/local/bin/start-hakuneko.sh
RUN chmod +x /usr/local/bin/start-hakuneko.sh

# Expose ports for kasmVNC
EXPOSE 6901

# Set default command to start kasmVNC and HakuNeko
CMD ["/usr/local/bin/start-hakuneko.sh"]

