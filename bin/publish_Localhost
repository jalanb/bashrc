#! /bin/bash

set -e
sudo chmod +w /var/www/index.html
sudo cp $1 /var/www/index.html
sudo chmod -w /var/www/index.html
sudo service apache2 --full-restart

