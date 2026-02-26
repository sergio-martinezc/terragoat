FROM python:3.9-slim-buster

# Evitamos interacciones de zona horaria que bloquean el build
ENV DEBIAN_FRONTEND=noninteractive

# 1. Limpieza y actualización con reintentos para estabilidad en Runners
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    git \
    unzip && \
    apt-get clean

# 2. Instalamos Terraform DIRECTO desde el binario (Evitamos problemas de repositorios APT)
# Esto es mucho más confiable en entornos corporativos/Runners
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# 3. Instalación de Checkov (Herramienta clave para Prisma/XSIAM)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir checkov

WORKDIR /app
COPY . /app/terragoat

# Validamos instalaciones
RUN terraform version && checkov --version

CMD ["/bin/bash"]
