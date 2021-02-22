#!/bin/bash
cd /var/www/html
echo "<html><h1>Hello from $(hostname)</h1></html>" > index.html
