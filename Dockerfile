FROM nginx:1.11.10

ENV MINISAT_VERSION 2.2.0

# download minisat
RUN apt-get update && \
    apt-get install -y \
    	    curl \
	    g++ \
	    make \
	    ruby \
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

EXPOSE 80 80

COPY files/gen-cnf.rb /opt/nginx/files/gen-cnf.rb
COPY files/index.html /usr/share/nginx/html/index.html
COPY files/nginx.conf /etc/nginx/nginx.conf