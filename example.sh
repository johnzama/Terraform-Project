#!/bin/bash
# Update the package index
sudo apt-get update -y

# Install Apache web server
sudo apt-get install apache2 -y

# Start the Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Create a simple HTML page
echo "<html><body><h1>Welcome to your web server!</h1></body></html>" | sudo tee /var/www/html/index.html

