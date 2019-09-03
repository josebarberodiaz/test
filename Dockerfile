FROM quay.io/openshift/origin-jenkins-agent-base



ENV JMETER_VERSION=5.1
ENV JMETER_HOME=/opt/jmeter
ENV JMETER_DIR=${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}

WORKDIR ${JMETER_HOME}

RUN wget -qO- http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz | tar xvz && \
    wget -P ${JMETER_DIR}/lib/ext https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/0.10/jmeter-plugins-manager-0.10.jar && \
    wget -P ${JMETER_DIR}/lib https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar 
    
#RUN ${JMETER_DIR}/bin/PluginsManagerCMD.sh install jpgc-casutg,jpgc-graphs-basic,jpgc-graphs-composite,jpgc-graphs-vs,jpgc-graphs-additional,jpgc-ggl,jpgc-cmd,jpgc-synthesis,jpgc-graphs-dist

RUN ln -s ${JMETER_DIR}/bin/jmeter /usr/bin/jmeter

WORKDIR /jmeter

