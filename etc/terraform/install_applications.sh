#! /bin/bash
sudo add-apt-repository ppa:ondrej/apache2 -y
sudo apt update
sudo apt-get install apache2 -y

echo $HOSTNAME | sudo tee /var/www/html/index.html



