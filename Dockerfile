FROM ubuntu:18.04

RUN apt update; apt install -y nginx-full openssh-server sshpass nano
#RUN apk update && apk add nginx-full openssh-server sshpass && rm -rf /var/cache/apk/*

RUN NGINXCONFFILE=/etc/nginx/nginx.conf && echo "daemon off;" | cat - $NGINXCONFFILE > $NGINXCONFFILE.tmp && mv $NGINXCONFFILE.tmp $NGINXCONFFILE

ADD content/default /etc/nginx/sites-enabled/

ADD content/index.html /sites

ADD content/run_servers.sh /

RUN mkdir /var/run/sshd

RUN echo "root:root"|chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

USER root

WORKDIR /usr/src/stream-music

#RUN apt-get update;apt-get install -y iputils-ping 
#sshpass

# RUN mkdir /var/run/sshd
# RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# RUN sed 's@session\srequired\spam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile
RUN passwd -d root
RUN echo PermitEmptyPasswords yes >> /etc/ssh/sshd_config
RUN echo PasswordAuthentication yes >> /etc/ssh/sshd_config

EXPOSE 80 22


CMD ["sh", "/run_servers.sh"]