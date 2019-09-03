FROM quay.io/openshift/origin-cli

MAINTAINER Jose Barbero Diaz <jbdiaz@indra.es>
ENV HOME=/home/jenkins

USER root
# Install headless Java
RUN INSTALL_PKGS="bc gettext git java-1.8.0-openjdk-headless lsof rsync tar unzip which zip bzip2 dumb-init" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V  $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /home/jenkins && \
    chown -R 1001:0 /home/jenkins && \
    chmod -R g+w /home/jenkins && \
    chmod 664 /etc/passwd && \
    chmod -R 775 /etc/alternatives && \
    chmod -R 775 /var/lib/alternatives && \
    chmod -R 775 /usr/lib/jvm && \
    chmod 775 /usr/bin && \
    chmod 775 /usr/lib/jvm-exports && \
    chmod 775 /usr/share/man/man1 && \
    mkdir -p /var/lib/origin && \
    chmod 775 /var/lib/origin && \    
    unlink /usr/bin/jjs && \
    unlink /usr/bin/keytool && \
    unlink /usr/bin/orbd && \
    unlink /usr/bin/pack200 && \
    unlink /usr/bin/policytool && \
    unlink /usr/bin/rmid && \
    unlink /usr/bin/rmiregistry && \
    unlink /usr/bin/servertool && \
    unlink /usr/bin/tnameserv && \
    unlink /usr/bin/unpack200 && \
    unlink /usr/lib/jvm-exports/jre && \
    unlink /usr/share/man/man1/java.1.gz && \
    unlink /usr/share/man/man1/jjs.1.gz && \
    unlink /usr/share/man/man1/keytool.1.gz && \
    unlink /usr/share/man/man1/orbd.1.gz && \
    unlink /usr/share/man/man1/pack200.1.gz && \
    unlink /usr/share/man/man1/policytool.1.gz && \
    unlink /usr/share/man/man1/rmid.1.gz && \
    unlink /usr/share/man/man1/rmiregistry.1.gz && \
    unlink /usr/share/man/man1/servertool.1.gz && \
    unlink /usr/share/man/man1/tnameserv.1.gz && \
    unlink /usr/share/man/man1/unpack200.1.gz

# Copy the entrypoint
ADD contrib/bin/* /usr/local/bin/

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/run-jnlp-client"]



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

EXPOSE 4445
ENTRYPOINT ["jmeter"]
