ln -s Dockerfile.lighttpd Dockerfile
heroku container:push web
rm Dockerfile
