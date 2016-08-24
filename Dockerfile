FROM debian:jessie

# WARNING: This expects there to be a release in the rel directory

MAINTAINER Nikko Miu <nikkoamiu@gmail.com>

# Install Dependencies
RUN apt-get update && apt-get install -y libssl1.0.0 imagemagick

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
RUN ln -s /usr/my_wedding/lib/my_wedding-$APP_VER/priv/static/uploads /mnt/uploads

# Runtime ENV
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV SECRET_KEY_BASE=xeqWUJ03Yx7JQ+if21rLBKIZ6cZKMyp3hcJYuC3U0NDQKe1APerQ3F5rD/E3s+e1
ENV GOOGLE_CLIENT_ID=someclientid.apps.googleusercontent.com
ENV GOOGLE_CLIENT_SECRET=somesecret
ENV RECAPTCHA_KEY=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
ENV RECAPTCHA_SECRET=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
ENV PORT=8080
ENV DB_HOST=192.168.99.100
ENV DB_BASE=my_wedding_prod
ENV DB_PASS=myweddingpassword
ENV RELX_REPLACE_OS_VARS=true

# Expose NGINX port
EXPOSE $PORT

# Show Volumes for Uploads
VOLUME ["/mnt/uploads"]

# Run startup script
CMD ["bin/my_wedding", "foreground"]
