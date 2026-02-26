# Cambiamos buster (EOL) por bullseye o bookworm (Soportadas)
FROM python:3.9-slim-bullseye

# Evitamos interacciones que bloquean el build
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalación de dependencias (Ahora sí encontrará los repositorios)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    git \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Instalación de Terraform (Directo desde binario para evitar fallos de repo)
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# 3. Instalación de Checkov (Seguridad Cloud)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir checkov

WORKDIR /app
COPY . /app/terragoat

# Validación rápida
RUN terraform version && checkov --version

CMD ["/bin/bash"]
