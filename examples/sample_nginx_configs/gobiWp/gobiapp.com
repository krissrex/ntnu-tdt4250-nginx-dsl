
## Wordpress server
server {
	listen 443 ssl;
	
	root /var/www/html;
	index index.php index.html index.htm;

	server_name gobiapp.com www.gobiapp.com;

	client_max_body_size 12m;

	error_page 404 /404.html;

	# SSL config
    ssl_certificate /etc/letsencrypt/live/live.gobiapp.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/live.gobiapp.com/privkey.pem; # managed by Certbot

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_dhparam /etc/ssl/certs/dhparam.pem;
	ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
	ssl_session_timeout 1d;
	ssl_session_cache shared:SSL:50m;
	ssl_stapling on;
	ssl_stapling_verify on;
	add_header Strict-Transport-Security max-age=15768000;


	##
	# We need to do some fixing before wordpress tries to highjack the links.
	#
	# Fix branch.io referral links
	# gobiapp.com/d?smsid=id3/asd31
	#
	# /d[ownload] [/] [? [*]]
	rewrite ^/download/index.php(.*)$ /d/index.php$1 last;
	rewrite ^/d(?:ownload)?/?(:?\?(.*))?$ /d/index.php?$1 last;
	#
	# Fix invite/referral links
	rewrite ^/ios/? /ios/index.php last;
	rewrite ^/android/? /android/index.php last;
	#
	# Fix ambassador applicant form
	rewrite ^/ambassador/?$ /ambassador/index.php last;
	# Fix get link
	rewrite ^/get/?$ /get/index.php last;

	location ^~ ^/(d|ios|android|ambassador|get)/?$ {
		root /var/www/gobiapp;
		index index.php index.html;
	}

	location ^~ ^/add/.* {
		root /var/www/gobiapp;
		index index.php index.html;
	}

	location /linkurl/ {
		rewrite  ^/linkurl/(.*)  /$1 break;
		proxy_pass http://127.0.0.1:8080;
	}

	location /.well-known {
		root /var/www/gobiapp;
#		index index.html index.php;
		allow all;
	}

	location /wp-content/ {
		root /var/www/wordpress;
		access_log off; 
		log_not_found off;
		expires max;
	}

	location /node/index.js{
		proxy_pass http://127.0.0.1:8080;
	}

	location /nginx_status {
		stub_status on;
		access_log off;
		allow 127.0.0.1;
		deny all;
	}

	# Rules for protected wordpress files
	include global/wp_restrictions.conf;

	# Directives to send expires headers and turn off 404 error logging.
	location ~* ^(?!/wp-content/).+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
		#valid_referers none blocked 52.59.229.56 gobiapp.no *.gobiapp.no gobiapp.com *.gobiapp.com gobitech.no *.gobitech.no;
		#if ($invalid_referer) {
		#	return   403;
		#}
		root /var/www/website;
		access_log off; 
		log_not_found off;
		expires max;
	}

	location = / {
		return 302 https://gobistories.co;
	}

	rewrite ^(.*)\.html$ $1 last;
	location / {
		# Remove .html extension from browser
		if ($request_uri ~ ^/(.*)\.html$) {  return 302 /$1;  }
		root /var/www/website;
		try_files $uri $uri/ $uri.html /index.php?$args;
	}

	location /404.html {
		root /var/www/website;
		internal;
	}

	# Pass all .php files onto a php-fpm/php-fcgi server.
	location ~ [^/]\.php(/|$) {
		root /var/www/wordpress;
		fastcgi_split_path_info ^(.+?\.php)(/.*)$;

		#if (!-f $document_root$fastcgi_script_name) {
		#	return 404;
		#}
		try_files $uri =404;
		# This is a robust solution for path info security issue and works with "cgi.fix_pathinfo = 1" in /etc/php.ini (default)

		
		include fastcgi.conf;
		fastcgi_index index.php;
	#	fastcgi_intercept_errors on;
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

    # Redirect non-https traffic to https
    # if ($scheme != "https") {
    #     return 301 https://$host$request_uri;
    # } # managed by Certbot


}


server {
    if ($host = gobiapp.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	server_name gobiapp.com www.gobiapp.com;
  return 404; # managed by Certbot
}