user              nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
	worker_connections 1024;
}

stream {
	# Specifies the main log format.
	log_format stream '$remote_addr [$time_local] $status "$connection"';

	access_log /dev/stdout stream;

	server {
		listen 0.0.0.0:80;
		proxy_pass validator:30333;
	}
}
