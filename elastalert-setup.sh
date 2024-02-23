#!/bin/bash

# Clone the ElastAlert repository
cd /etc/
git clone https://github.com/Yelp/elastalert.git

# Install required packages
sudo apt update
sudo apt install -y python3 python3-pip python3-setuptools python3-wheel

# Install ElastAlert
pip3 install elastalert

# Install setuptools if needed
pip3 install "setuptools>=11.3"

# Change directory to ElastAlert
cd /etc/elastalert

# Install ElastAlert using setup.py
python3 setup.py install

# Create a symbolic link to elastalert.py in /usr/local/bin to make ElastAlert easier to run
sudo ln -s /etc/elastalert/elastalert.py /usr/local/bin/elastalert

# Create the systemd service file for ElastAlert
cat << EOF | sudo tee /etc/systemd/system/elastalert.service
[Unit]
Description=ElastAlert service
After=network.target

StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/elastalert --config /etc/elastalert/config.yaml --verbose

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to read the new service file
sudo systemctl daemon-reload

# Start and enable the ElastAlert service
echo -n "sudo systemctl start elastalert.service"
echo -n "sudo systemctl enable elastalert.service"








