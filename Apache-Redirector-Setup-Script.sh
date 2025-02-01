#!/bin/bash

# This script sets up an Apache server on an Ubuntu system. It includes steps for updating the system,
# installing Apache, setting up basic security with mod_security and certbot for SSL, and configuring Apache
# to hide its identity and to improve security settings.

# Linode env variables for domain
# <UDF name="mydomain" Label="Domain Name" />

if [ -z "$1" ]; then
    echo "[!] Error: No argument provided."
    echo "Usage: $0 <domain.com>"
    echo "Usage: $0 <sub.domain.com>"
    exit 1
fi

# Update the system's package index files from their sources.
echo "[+] Updating apt..."
sudo apt update

# Begin Apache server setup
echo "[+] Setting up Apache."

# Install Apache2 and automatically confirm installation with '-y'
sudo apt install apache2 -y

# Enable Apache2 to start on boot using systemctl
sudo systemctl enable apache2

# Install Certbot and its Apache plugin for obtaining SSL certificates
sudo apt install certbot python3-certbot-apache -y

# Install the Apache module 'mod_security2' for enhancing security
sudo apt install libapache2-mod-security2 -y

# Disable the default Apache site configuration
sudo a2dissite 000-default.conf

# Enable various Apache modules necessary for reverse proxying, security improvements, and content rewriting
sudo a2enmod proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html

# Disable the autoindex module forcefully to prevent directory listings
sudo a2dismod autoindex -f

# Enable the security module for Apache
sudo a2enmod security2

# Update the Apache security config to turn off server signature
sudo sed -i "s/ServerSignature On/ServerSignature Off/g" /etc/apache2/conf-available/security.conf

# Add a line to the Apache security config to fake the server signature as Microsoft-IIS/10.0
echo "SecServerSignature Microsoft-IIS/10.0" | sudo tee -a /etc/apache2/conf-available/security.conf

# Update the Apache security config to display full server tokens
sudo sed -i "s/ServerTokens OS/ServerTokens Full/g" /etc/apache2/conf-available/security.conf

# restaring Apache
echo "[+] Restarting Apache to apply changes."

# Restart Apache to apply all the changes made to its configuration
sudo systemctl restart apache2

# Disable SSH password authentication and only allow key auth
 sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

 # Misc package installations
 apt install net-tools -y
 apt install unzip

echo "[+] Server setup complete."

echo "[+] Starting Domain Setup."

MYDOMAIN=$1

echo "[+] Using $MYDOMAIN"

# Start Domain Setup:
echo "[+] Creating $MYDOMAIN directories.."
sudo mkdir /var/www/$MYDOMAIN
sudo chown -R root:root /var/www/$MYDOMAIN
sudo chmod -R 755 /var/www/$MYDOMAIN
sudo mkdir /var/www/$MYDOMAIN/logs
echo "[+] Done."

#Setup Virtual Host file
echo "[+] Setting up the Apache virtual host file.."
sudo echo -e "<VirtualHost *:80>    \n\tServerAdmin webmaster@localhost    \n\tServerName $MYDOMAIN    \n\tServerAlias www.$MYDOMAIN     \n\tDocumentRoot /var/www/$MYDOMAIN    \n\tErrorLog ${APACHE_LOG_DIR}/error.log    \n\tCustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>" >> /etc/apache2/sites-available/$MYDOMAIN.conf
sudo a2ensite $MYDOMAIN.conf
sudo systemctl restart apache2

# Check for domain to resolve:
while true; do
    nc $MYDOMAIN 80 < /dev/null
    if [ $? -eq 0 ]; then
        break
    fi
    echo "[!] Sleeping 2.5 mins for DNS resolve"
    sleep 150
done

# Final Domain Setup
echo "[+] Using Certbot to request a certificate for $MYDOMAIN."
sudo certbot --apache --email admin@$MYDOMAIN --agree-tos --no-eff-email -d $MYDOMAIN --redirect --hsts --uir
echo "[+] Certbot request done."
sudo systemctl restart apache2

#Final service restarts
echo "[+] Restarting services apply changes."
sudo systemctl restart apache2
systemctl restart sshd.service

echo "[+] Domain setup script complete."
exit 0
