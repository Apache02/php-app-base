location ~ \.php$ {
    fastcgi_param   HTTP_X_REAL_IP $remote_addr;
    fastcgi_pass unix:/run/php-fpm.sock;
    fastcgi_index index.php;
    fastcgi_split_path_info ^(.+\.php)(/.*)$;
    include fastcgi_params;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param  HTTPS off;
    try_files $uri =404;

}
