FROM python:3.9-slim-buster

LABEL maintainer="Professional Services - Palo Alto Networks"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Instalamos dependencias básicas incluyendo lsb-release y ca-certificates
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    software-properties-common \
    lsb-release \
    ca-certificates \
    git \
    && apt-get clean

# Instalación de Terraform usando el método recomendado actual
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Instalación de Checkov para escaneo de seguridad
RUN pip install --no-cache-dir checkov

WORKDIR /app

# Nota: Asegúrate de tener el código de TerraGoat en el mismo directorio que este Dockerfile
COPY . /app/terragoat

CMD ["/bin/bash", "-c", "terraform version && checkov --version && /bin/bash"]
