server {
	listen 80;
	listen [::]:80;
	server_name admin.gobiapp.com;

	# To update cert with certbot, comment the return 301, and uncomment the block below
	#
	#location / {
	#	root /var/www/admin/;
	#	try_files $uri $uri/ =404;
	#}

	return 301 https://$host;

    # Redirect non-https traffic to https
    # if ($scheme != "https") {
    #     return 301 https://$host$request_uri;
    # } # managed by Certbot

}

server {
	listen 443 ssl;

	root /var/www/admin/;
	index index.html index.htm index.php;

	# Make site accessible from http://admin.gobiapp.no
	server_name admin.gobiapp.com;

	# SSL config
ssl_certificate /etc/letsencrypt/live/gobiapp.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/gobiapp.com/privkey.pem; # managed by Certbot

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_session_timeout 1d;
        ssl_session_cache shared:SSL:50m;
        ssl_stapling on;
        ssl_stapling_verify on;
        add_header Strict-Transport-Security max-age=15768000;

	location ~ /(framework|partials)/ {
		deny all;
		return 403;
	}


	location / {
		expires -1;
		try_files $uri $uri/ $uri.php?$args;
	}


	error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /usr/share/nginx/html;
	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		# Strip .php
		if ($request_uri ~ ^/([^?]*)\.php($|\?)) {  return 302 /$1?$args;  }
    		try_files $uri =404;

		fastcgi_split_path_info ^(.+\.php)(/.+)$;
	#	# NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
	#
	#	# With php5-cgi alone:
	#	fastcgi_pass 127.0.0.1:9002;
	#	# With php7-fpm:
		fastcgi_pass unix:/run/php/php7.0-fpm_gobi-admin.sock;
		fastcgi_index index.php;
		include fastcgi.conf;
	}
}

