FROM httpd:2.4

ENV MINISAT_VERSION 2.2.0

# download minisat
RUN apt-get update && \
    apt-get install -y \
    	    curl \
	    g++ \
	    gem \
	    make \
	    ruby \
	    yum \
	    zlib1g-dev

RUN curl -L http://minisat.se/downloads/minisat-${MINISAT_VERSION}.tar.gz \
    >/tmp/minisat-${MINISAT_VERSION}.tar.gz && \
    cd /tmp && \
    tar zxf minisat-${MINISAT_VERSION}.tar.gz

# build minisat
# Reference: http://bach.istc.kobe-u.ac.jp/lect/tamlab/ubuntu11-10/programming.html
RUN cd /tmp/minisat && \
    export MROOT=`pwd` && \
    cd core && make rs && cd .. && \
    cd simp && make rs && cd .. && \
    cp -p core/minisat_static /usr/local/bin/minisat22_core && \
    cp -p simp/minisat_static /usr/local/bin/minisat22_simp

# install
RUN cd /usr/local/bin && \
    ln -s minisat22_core minisat


# Ref: https://github.com/senyoltw/docker-difff/blob/master/Dockerfile
RUN sed -ri 's/#LoadModule cgid_module/LoadModule cgid_module/g; \ 
             s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g; \
             s/#AddHandler cgi-script .cgi/AddHandler cgi-script .rb .pl .cgi/g' /usr/local/apache2/conf/httpd.conf


EXPOSE 80 80

COPY files/gen-cnf.rb /usr/local/apache2/htdocs/gen-cnf.rb
RUN chmod a+x /usr/local/apache2/htdocs/gen-cnf.rb
COPY files/handler.rb /usr/local/apache2/htdocs/handler.rb
RUN chmod a+x /usr/local/apache2/htdocs/handler.rb
COPY files/index.html /usr/local/apache2/htdocs/index.html
