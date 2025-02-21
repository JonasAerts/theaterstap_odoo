FROM odoo:16
USER root
RUN apt-get update && apt-get upgrade -y
WORKDIR /opt/odoo/parts/custom
COPY ./addons .
