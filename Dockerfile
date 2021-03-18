FROM docker.io/library/alpine:3.13

LABEL 'com.github.actions.name'='PHP_CodeSniffer code analysis'
LABEL 'com.github.actions.description'='PHP static code analysis using PHP_CodeSniffer'

RUN apk --no-cache add \
    jq=~1 \
    php7=~7.4 \
    php7-ctype=~7.4 \
    php7-dom=~7.4 \
    php7-fileinfo=~7.4 \
    php7-intl=~7.4 \
    php7-json=~7.4 \
    php7-phar=~7.4 \
    php7-simplexml=~7.4 \
    php7-sockets=~7.4 \
    php7-tokenizer=~7.4 \
    php7-xml=~7.4 \
    php7-xmlwriter=~7.4

RUN wget -q -O /usr/local/bin/phpcs 'https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.8/phpcs.phar' \
    && chmod +x /usr/local/bin/phpcs

RUN wget -q -O /usr/local/bin/phpcbf 'https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.8/phpcbf.phar' \
    && chmod +x /usr/local/bin/phpcbf

COPY Standards/DDC_CodeSniffer/DDC /usr/local/shared/phpcs/Standards/DDC
COPY Standards/PHPCompatibility/PHPCompatibility /usr/local/shared/phpcs/Standards/PHPCompatibility
COPY Standards/PHPCompatibility/PHPCSAliases.php /usr/local/shared/phpcs/Standards/PHPCSAliases.php
RUN /usr/local/bin/phpcs --config-set 'installed_paths' '/usr/local/shared/phpcs/Standards'

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN mkdir /app
WORKDIR /app
