# Use a base image with Python installed
FROM python:3.8-slim

# Install other dependencies
RUN apt-get update && \
    apt-get install -y git build-essential vim nano locate net-tools procps && \
    rm -rf /var/lib/apt/lists/*

# Install necessary dependencies for ElastAlert and systemd
RUN apt-get update && \
    apt-get install -y git systemd && \
    rm -rf /var/lib/apt/lists/*

# Enable systemd in container
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Clone the ElastAlert repository
RUN git clone https://github.com/Yelp/elastalert.git /opt/elastalert

# Change directory to ElastAlert
WORKDIR /opt/elastalert

# Copy the ElastAlert configuration file
# COPY config.yaml /opt/elastalert/config.yaml

# Copy the ElastAlert rules directory
# COPY rules /opt/elastalert/rules

# Install ElastAlert
RUN pip install -e .

# Set the entrypoint to ElastAlert
ENTRYPOINT ["python", "-m", "elastalert.elastalert"]

# Build for image
# docker build -t elastalert .

# Run for Docker container
# docker exec -it my-elastalert /bin/bash
