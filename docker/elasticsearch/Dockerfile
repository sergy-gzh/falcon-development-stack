FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.1

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic && \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu