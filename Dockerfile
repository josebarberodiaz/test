FROM quay.io/openshift/origin-jenkins-agent-base



ENV JMETER_VERSION=5.1
ENV JMETER_HOME=/opt/jmeter
ENV JMETER_DIR=${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}

WORKDIR ${JMETER_HOME}

RUN wget -qO- http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz | tar xvz && \
    wget -P ${JMETER_DIR}/lib/ext https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/0.10/jmeter-plugins-manager-0.10.jar && \
    wget -P ${JMETER_DIR}/lib https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.17/mysql-connector-java-8.0.17.jar && \
    wget -P ${JMETER_DIR}/lib https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar 
    
#Kafka plugin
COPY jmeter.backendlistener.kafka-1.0.0.jar ${JMETER_HOME}/lib/ext
COPY jmeter-plugins-manager-1.3.jar ${JMETER_HOME}/lib/ext

RUN ln -s ${JMETER_DIR}/bin/jmeter /usr/bin/jmeter

WORKDIR /jmeter

