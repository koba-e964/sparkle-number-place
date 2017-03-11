FROM httpd:2.4

ENV MINISAT_VERSION 2.2.0

RUN apt-get update && \
    apt-get install -y \
    	    curl \
	    g++ \
	    gem \
	    make \
	    ruby \
	    yum \
	    zlib1g-dev

# download minisat
RUN curl -L http://minisat.se/downloads/minisat-${MINISAT_VERSION}.tar.gz \
    >/tmp/minisat-${MINISAT_VERSION}.tar.gz && \
    cd /tmp && \
    tar zxf minisat-${MINISAT_VERSION}.tar.gz && \
    rm minisat-${MINISAT_VERSION}.tar.gz

# build & install minisat
# Reference: http://bach.istc.kobe-u.ac.jp/lect/tamlab/ubuntu11-10/programming.html
RUN cd /tmp/minisat && \
    export MROOT=`pwd` && \
    cd core && make rs && cd .. && \
    cd simp && make rs && cd .. && \
    cp -p core/minisat_static /usr/local/bin/minisat22_core && \
    cp -p simp/minisat_static /usr/local/bin/minisat22_simp && \
    ln -s /usr/local/bin/minisat22_core /usr/local/bin/minisat && \
    cd / && rm -r /tmp/minisat

COPY files/gen-cnf.rb /usr/local/apache2/htdocs/gen-cnf.rb
RUN chmod a+x /usr/local/apache2/htdocs/gen-cnf.rb
COPY files/handler.rb /usr/local/apache2/htdocs/handler.rb
RUN chmod a+x /usr/local/apache2/htdocs/handler.rb
COPY files/index.html /usr/local/apache2/htdocs/index.html
COPY files/start-server.sh /usr/local/apache2/htdocs/start-server.sh
RUN chmod a+x /usr/local/apache2/htdocs/start-server.sh

CMD ["/usr/local/apache2/htdocs/start-server.sh"]