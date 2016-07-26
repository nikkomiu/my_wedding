FROM elixir:1.3

# WARNING: This expects there to be a release in the rel directory

MAINTAINER Nikko Miu <nikkoamiu@gmail.com>

# Install NGINX
RUN curl https://gist.githubusercontent.com/nikkomiu/cd15d615fc3390ebbd79e9d078458d10/raw/nginx_install.sh | bash -s 1.11.2

# Move NGINX config into place
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Build Arguments
ARG APP_VER=0.0.1
ARG MIX_ENV=prod

# Copy release
COPY rel/my_wedding/releases/$APP_VER/my_wedding.tar.gz /usr/my_wedding/app.tar.gz
WORKDIR /usr/my_wedding

# Extract release
RUN tar -xvf app.tar.gz
RUN chmod +x bin/my_wedding

# Create Symlink for Uploads
RUN ln -s /usr/my_wedding/lib/my_wedding-$APP_VER/priv/static/uploads /uploads

# Copy start script
COPY deploy/run.sh /usr/my_wedding/bin
RUN chmod +x bin/run.sh

# Runtime ENV
ENV GOOGLE_CLIENT_ID=someclientid.apps.googleusercontent.com
ENV GOOGLE_CLIENT_SECRET=somesecret
ENV SECRET_KEY_BASE=xeqWUJ03Yx7JQ+if21rLBKIZ6cZKMyp3hcJYuC3U0NDQKe1APerQ3F5rD/E3s+e1
ENV DB_HOST=192.168.99.100
ENV DB_BASE=my_wedding_prod
ENV DB_USER=my_wedding_svc
ENV DB_PASS=myweddingpassword

# Expose NGINX port
EXPOSE 80

# Show Volumes for NGINX SSL and Uploads
VOLUME ["/etc/nginx/ssl", "/uploads"]

# Run startup script
CMD ["bin/run.sh"]
