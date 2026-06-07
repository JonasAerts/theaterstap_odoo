FROM ubuntu:22.04

# Avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    python3-venv \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    libmysqlclient-dev \
    libjpeg-dev \
    libpq-dev \
    liblcms2-dev \
    libv4l-dev \
    libxrender1 \
    libfontconfig1 \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
    curl \
    git \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf
RUN curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb \
    && apt-get update && apt-get install -y ./wkhtmltox.deb \
    && rm wkhtmltox.deb

# Create odoo user
RUN useradd -m -d /opt/odoo -s /bin/bash odoo

# Clone Odoo source directly into /opt/odoo
WORKDIR /opt/odoo
RUN find . -mindepth 1 -delete \
    && git clone --depth 1 --branch 19.0 https://www.github.com/odoo/odoo .

# Install Python dependencies
# We manually install build tools and gevent first to avoid build isolation 
# pulling Cython 3.x, which is incompatible with gevent 21.8.0.
RUN pip3 install --no-cache-dir "Cython<3.0" "setuptools<70" "wheel" \
    && pip3 install --no-cache-dir --no-build-isolation gevent==21.8.0 \
    && pip3 install --no-cache-dir -r requirements.txt

# Set up directories for configuration and custom addons
RUN mkdir -p /etc/odoo /mnt/extra-addons /var/lib/odoo
RUN chown -R odoo:odoo /opt/odoo /etc/odoo /mnt/extra-addons /var/lib/odoo

# Copy configuration file
COPY ./config/odoo.conf /etc/odoo/odoo.conf
RUN chown odoo:odoo /etc/odoo/odoo.conf

# Add odoo to PATH
ENV PATH="/opt/odoo:${PATH}"

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC="/etc/odoo/odoo.conf"

USER odoo

ENTRYPOINT ["python3", "odoo-bin"]
