server {
	listen 80;
	listen [::]:80;
	server_name stats.gobiapp.com;

	location /.well-known/ {
		root /var/www/stats/;
		try_files $uri =404;
	}
	
	# comment out when updating SSL keys with certbot:
	return 301 https://$host;

    # Redirect non-https traffic to https
    # if ($scheme != "https") {
    #     return 301 https://$host$request_uri;
    # } # managed by Certbot

}

server {
	listen 443 ssl;
	root /var/www/stats/;
	index index.html index.htm;

	server_name stats.gobiapp.com;

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


	#location / {
	#	try_files $uri $uri/ =404;
	#}

	error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /usr/share/nginx/html;
	}


#        location / {
#                sendfile on;
#        	expires max;
#                try_files $uri $uri/ /index.html;
#        }


	location / {
    # Proxy to metabase java app
    #proxy_set_header Upgrade $http_upgrade;
    #proxy_set_header Connection "upgrade";
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_http_version 1.1;
    proxy_pass http://127.0.0.1:3143;
  }
}
