server {
    listen 80;

    root /var/www/theSwipers;
    index index.php index.html index.htm;

    server_name theswipers.com www.theswipers.com;
 
    add_header Strict-Transport-Security max-age=15768000;


    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
    }

}

