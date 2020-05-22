FROM php:fpm-alpine

ENV COMPOSER_HOME /composer
ENV PATH /opt/node/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

ARG NODE_VERSION=14.3.0
ARG bat_ver=0.15.1
ARG diskus_ver=0.6.0
ARG fd_ver=8.1.0
ARG fzf_ver=0.21.1
ARG hyperfine_ver=1.9.0
ARG ripgrep_ver=12.1.0
ARG starship_ver=0.41.3

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      curl-dev \
      imagemagick-dev \
      libtool \
      libxml2-dev \
      postgresql-dev \
      sqlite-dev \
# Install production dependencies
  && apk add --no-cache \
      bash \
      curl \
      freetype-dev \
      g++ \
      gcc \
      git \
      icu-dev \
      icu-libs \
      imagemagick \
      libc-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      libzip-dev \
      make \
      mysql-client \
      oniguruma-dev \
      openssh-client \
      postgresql-libs \
      rsync \
      zlib-dev \
# Install PECL and PEAR extensions
  && pecl install \
      imagick \
      xdebug \
      ast \
# Enable PECL and PEAR extensions
  && docker-php-ext-enable \
      imagick \
      xdebug \
      ast \
# Configure php extensions
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
# Install php extensions
  && docker-php-ext-install \
      bcmath \
      calendar \
      curl \
      exif \
      gd \
      iconv \
      intl \
      mbstring \
      pdo \
      pdo_mysql \
      pdo_pgsql \
      pdo_sqlite \
      pcntl \
      tokenizer \
      xml \
      zip \
# Install composer
  && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
# Install PHP_CodeSniffer
  && composer global require "squizlabs/php_codesniffer=*" \
# Install Node
  && curl -fsSL --compressed -o node.tar.xz "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64-musl.tar.xz" \
  && mkdir -p /opt/node \
  && tar -xJf node.tar.xz -C /opt/node --wildcards "*/*/*" --strip-components 1 --no-same-owner \
  && node --version \
  && rm -f node.tar.xz \
# Install typescript
  && npm install -g typescript \
  && tsc --version \
# Cleanup dev dependencies
  && apk del -f .build-deps \
# Install bat
  && curl -fL -o bat.tar.gz "https://github.com/sharkdp/bat/releases/download/v${bat_ver}/bat-v${bat_ver}-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf bat.tar.gz -C /usr/local/bin --wildcards "*/bat" --strip-components 1 \
  && rm bat.tar.gz \
  && bat --version \
# Install diskus
  && curl -fL -o diskus.tar.gz "https://github.com/sharkdp/diskus/releases/download/v${diskus_ver}/diskus-v${diskus_ver}-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf diskus.tar.gz -C /usr/local/bin --wildcards "*/diskus" --strip-components 1 \
  && rm diskus.tar.gz \
  && diskus --version \
# Install fd
  && curl -fL -o fd.tar.gz "https://github.com/sharkdp/fd/releases/download/v${fd_ver}/fd-v${fd_ver}-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf fd.tar.gz -C /usr/local/bin --wildcards "*/fd" --strip-components 1 \
  && rm fd.tar.gz \
  && fd --version \
# Install fzf
  && curl -fL -o fzf.tgz "https://github.com/junegunn/fzf-bin/releases/download/${fzf_ver}/fzf-${fzf_ver}-linux_amd64.tgz" \
  && tar -xzvf fzf.tgz -C /usr/local/bin \
  && rm fzf.tgz \
  && fzf --version \
# Install hyperfine
  && curl -fL -o hyperfine.tar.gz "https://github.com/sharkdp/hyperfine/releases/download/v${hyperfine_ver}/hyperfine-v${hyperfine_ver}-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf hyperfine.tar.gz -C /usr/local/bin --wildcards "*/hyperfine" --strip-components 1 \
  && rm hyperfine.tar.gz \
  && hyperfine --version \
# Install ripgrep
  && curl -fL -o ripgrep.tar.gz "https://github.com/BurntSushi/ripgrep/releases/download/${ripgrep_ver}/ripgrep-${ripgrep_ver}-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf ripgrep.tar.gz -C /usr/local/bin --wildcards "*/rg" --strip-components 1 \
  && rm ripgrep.tar.gz \
  && rg --version \
# Install starship
  && curl -fL -o starship.tar.gz "https://github.com/starship/starship/releases/download/v${starship_ver}/starship-x86_64-unknown-linux-musl.tar.gz" \
  && tar -xzvf starship.tar.gz -C /usr/local/bin \
  && rm starship.tar.gz \
  && echo 'eval "$(starship init bash)"' >> /root/.bashrc \
# fix 'dh key too small'
  && sed -i "s|DEFAULT@SECLEVEL=2|DEFAULT@SECLEVEL=1|g" /etc/ssl/openssl.cnf

COPY starship.toml /root/.config

EXPOSE 3000 8000 8080

CMD [ "bash" ]