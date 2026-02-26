# Usamos una imagen base ligera de Python
FROM python:3.9-slim-buster

# Metadatos de la imagen
LABEL maintainer="Professional Services - Palo Alto Networks"
LABEL description="Entorno para despliegue y análisis de seguridad de TerraGoat"

# Evitar que Python genere archivos .pyc y permitir logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Instalar dependencias del sistema y Terraform
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    software-properties-common \
    git \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install -y terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas de seguridad (Checkov) para alineación con XSIAM/Prisma
RUN pip install --no-cache-dir checkov

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el repositorio de TerraGoat al contenedor
# Nota: Asegúrate de estar en la raíz del repo de TerraGoat al buildear
COPY . /app/terragoat

# Exponer un volumen para persistencia de planes de Terraform
VOLUME ["/app/plans"]

# Comando por defecto: Mostrar versión de Terraform y Checkov
CMD ["/bin/bash", "-c", "terraform version && checkov --version && /bin/bash"]
