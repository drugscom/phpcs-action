FROM alpine:3.15.4

LABEL 'com.github.actions.name'='PHP_CodeSniffer code analysis'
LABEL 'com.github.actions.description'='PHP static code analysis using PHP_CodeSniffer'

RUN apk --no-cache add \
    jq=~1 \
    php8=~8.0 \
    php8-ctype=~8.0 \
    php8-dom=~8.0 \
    php8-fileinfo=~8.0 \
    php8-intl=~8.0 \
    php8-phar=~8.0 \
    php8-simplexml=~8.0 \
    php8-sockets=~8.0 \
    php8-tokenizer=~8.0 \
    php8-xml=~8.0 \
    php8-xmlwriter=~8.0 \
    && ln -s /usr/bin/php8 /usr/local/bin/php

RUN wget -q -O /usr/local/bin/phpcs 'https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.6.0/phpcs.phar' \
    && chmod +x /usr/local/bin/phpcs

RUN wget -q -O /usr/local/bin/phpcbf 'https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.6.0/phpcbf.phar' \
    && chmod +x /usr/local/bin/phpcbf

COPY Standards/DDC_CodeSniffer/DDC /usr/local/shared/phpcs/Standards/DDC
COPY Standards/PHPCompatibility/PHPCompatibility /usr/local/shared/phpcs/Standards/PHPCompatibility
COPY Standards/PHPCompatibility/PHPCSAliases.php /usr/local/shared/phpcs/Standards/PHPCSAliases.php
RUN /usr/local/bin/phpcs --config-set 'installed_paths' '/usr/local/shared/phpcs/Standards'

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

WORKDIR /app
