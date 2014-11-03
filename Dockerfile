FROM ubuntu:14.04
MAINTAINER Carsten Ehbrecht <ehbrecht@dkrz.de>

RUN apt-get update

# install project requirements
ADD ./requirements.sh /tmp/requirements.sh  
RUN cd /tmp && bash requirements.sh && cd -

RUN useradd -d /home/phoenix -m phoenix
ADD . /home/phoenix/src
RUN chown -R phoenix /home/phoenix/src

USER phoenix
WORKDIR /home/phoenix/src

RUN bash bootstrap.sh && make all

WORKDIR /home/phoenix/anaconda

EXPOSE 8090 8094 9001

#CMD bin/supervisord -n -c etc/supervisor/supervisord.conf && bin/nginx -c etc/nginx/nginx.conf -g 'daemon off;
CMD etc/init.d/supervisord start && bin/nginx -c etc/nginx/nginx.conf -g 'daemon off;'

