server {
	listen 80;
	listen [::]:80;
	listen 443 ssl;
	root /var/www/live2/;
	index index.html index.htm;

	server_name live2.gobiapp.com;

	error_page 404 /404.html;

    ssl_certificate /etc/letsencrypt/live/gobiapp.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/gobiapp.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot


	return 301 https://live.gobiapp.com$request_uri;

}
