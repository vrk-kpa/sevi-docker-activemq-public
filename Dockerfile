FROM java:8-jre

ENV AMQ_VERSION 5.13.0
ENV AMQ_HOME /opt/apache-activemq

EXPOSE 61612 61613 61616 8161

RUN curl http://www.mirrorservice.org/sites/ftp.apache.org/activemq/$AMQ_VERSION/apache-activemq-$AMQ_VERSION-bin.tar.gz | tar -xz \
    && mv apache-activemq-$AMQ_VERSION/conf/activemq.xml apache-activemq-$AMQ_VERSION/conf/activemq.xml.orig \
    && awk '/.*stomp.*/{print "            <transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl://0.0.0.0:61612?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" />"}1' apache-activemq-$AMQ_VERSION/conf/activemq.xml.orig >> apache-activemq-$AMQ_VERSION/conf/activemq.xml

CMD java -Xms1G -Xmx1G -Djava.util.logging.config.file=logging.properties \
    -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote \
    -Djava.io.tmpdir=apache-activemq-$AMQ_VERSION/tmp -Dactivemq.classpath=apache-activemq-$AMQ_VERSION/conf \
    -Dactivemq.home=apache-activemq-$AMQ_VERSION -Dactivemq.base=apache-activemq-$AMQ_VERSION \
    -Dactivemq.conf=apache-activemq-$AMQ_VERSION/conf -Dactivemq.data=apache-activemq-$AMQ_VERSION/data \
    -jar apache-activemq-$AMQ_VERSION/bin/activemq.jar start
