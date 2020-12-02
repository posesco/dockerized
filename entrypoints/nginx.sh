#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

CONF_AVAILABLE_DIR="/etc/nginx/conf-available"
CONF_ENABLED_DIR="/etc/nginx/conf-enabled"
SITES_AVAILABLE_DIR="/etc/nginx/sites-available"
SITES_ENABLED_DIR="/etc/nginx/sites-enabled"

NGINX_CUSTOM_CONF_DIR="/opt/iredmail/custom/nginx"
NGINX_CUSTOM_ENABLED_CONF_DIR="/opt/iredmail/custom/nginx/conf-enabled"
NGINX_CUSTOM_ENABLED_SITES_DIR="/opt/iredmail/custom/nginx/sites-enabled"
NGINX_CUSTOM_SITES_CONF_DIR="/opt/iredmail/custom/nginx/sites-conf.d"
NGINX_CUSTOM_DEFAULT_SITE_CONF_DIR="/opt/iredmail/custom/nginx/sites-conf.d/default"
NGINX_CUSTOM_DEFAULT_SSL_SITE_CONF_DIR="/opt/iredmail/custom/nginx/sites-conf.d/default-ssl"
NGINX_CUSTOM_WEBAPP_CONF_DIR="/opt/iredmail/custom/nginx/webapps"

sites="00-default.conf 00-default-ssl.conf"
[[ X"${USE_AUTOCONFIG}" == X'YES' ]] && sites="${sites} autoconfig.conf"

[[ -d ${CONF_ENABLED_DIR} ]] || mkdir -p ${CONF_ENABLED_DIR}
[[ -d ${SITES_ENABLED_DIR} ]] || mkdir -p ${SITES_ENABLED_DIR}

for dir in \
    ${NGINX_CUSTOM_CONF_DIR} \
    ${NGINX_CUSTOM_ENABLED_CONF_DIR} \
    ${NGINX_CUSTOM_ENABLED_SITES_DIR} \
    ${NGINX_CUSTOM_SITES_CONF_DIR} \
    ${NGINX_CUSTOM_DEFAULT_SITE_CONF_DIR} \
    ${NGINX_CUSTOM_DEFAULT_SSL_SITE_CONF_DIR} \
    ${NGINX_CUSTOM_WEBAPP_CONF_DIR}; do
    install -d -o ${SYS_USER_ROOT} -g ${SYS_GROUP_ROOT} -m 0777 ${dir}
done

for site in ${sites}; do
    ln -sf ${SITES_AVAILABLE_DIR}/${site} ${SITES_ENABLED_DIR}/${site}
done

for conf in $(ls ${CONF_AVAILABLE_DIR}/*.conf); do
    f="$(basename ${conf})"
    ln -sf ${CONF_AVAILABLE_DIR}/${f} ${CONF_ENABLED_DIR}/${f}
done

[[ X"${USE_IREDADMIN}" == X'YES' ]] || rm -f ${CONF_ENABLED_DIR}/iredadmin.conf
