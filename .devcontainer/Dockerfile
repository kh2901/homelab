# Use a base image with Python and Ansible pre-installed
FROM debian:trixie-backports

# install certs
RUN apt-get update && apt-get install -y wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# Download the installer script:
# RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
RUN apt-get update && apt-get install -y wget ca-certificates \
    && wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh \
    && chmod +x install-opentofu.sh \
    && ./install-opentofu.sh --install-method deb \
    && rm -f install-opentofu.sh \
    && apt-get purge -y wget \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -ms /bin/bash vscode
USER vscode

# Set the working directory
WORKDIR /workspace