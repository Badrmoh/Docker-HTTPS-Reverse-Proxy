rFROM ubuntu
MAINTAINER engbadr@outlook.com
RUN apt-get update && \
    apt-get -y install nginx-full && \
    apt-get -y install software-properties-common && \
    apt-get -y upgrade && \
    add-apt-repository ppa:certbot/certbot-build && \
    apt-get update && \
    apt-get -y install python-certbot-nginx && \
    apt-get autoremove -y && \
    apt-get clean -y 
VOLUME ./nginx.conf:/etc/nginx/nginx.conf
VOLUME ./letsencrypt/:/etc/letsencrypt/
EXPOSE 80 443 53
ENV EMAIL = "engbadr@outlook.com"
ENV DOMAIN = "badronline.crabdance.com"
CMD systemctl restart nginx
CMD certbot --authenticator standalone --installer nginx --pre-hook "service nginx stop" --post-hook "service nginx start" --agree-tos -m $EMAIL -d $DOMAIN --keep && bash

