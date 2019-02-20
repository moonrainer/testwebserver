FROM registry.access.redhat.com/rhel7

MAINTAINER Tremolo Security, Inc. - Docker <docker@tremolosecurity.com>



LABEL name="Unison" \
      vendor="Tremolo Security, Inc." \
      version="1.0.15" \
      release="20180700601" \
### Recommended labels below
      url="https://www.tremolosecurity.com/unison/" \
      summary="Cloud Native Identity Management" \
      description="Unison is an identity management platforms that can provide solutions for applications and infrastructure. Services include user provisioning, web access management & SSO, LDAP virtual directory and a user self service portal." \
      run='docker run -tdi --name ${NAME} -v /path/to/unison:/usr/local/tremolo/tremolo-service/external:Z ${IMAGE}' \
      io.k8s.description="Cloud Native Identity Management" \
      io.k8s.display-name="Unison" \
      io.openshift.expose-services="8080:http,8443:https,10983:ldap,10636:ldaps,9090:https-admin" \
      io.openshift.tags="identity management,sso,ldap,user provisioning,devops,saml,openid connect"




EXPOSE 9090
EXPOSE 8080
EXPOSE 8443


ENV UNISON_VERSION 1.0.15
ENV MYSQL_JDBC_VERSION 5.1.38
ENV PGSQL_JDBC_VERSION 9.4.1209.jre7


USER root
ADD scripts/firstStart.sh /tmp/firstStart.sh
ADD scripts/startUnisonInDocker.sh /tmp/startUnisonInDocker.sh
ADD conf/log4j2.xml /tmp/log4j2.xml
ADD metadata/help.md /tmp/help.md

COPY licenses /licenses

RUN   REPOLIST="rhel-7-server-rpms,rhel-7-server-optional-rpms" && \
      INSTALL_PKGS="golang-github-cpuguy83-go-md2man wget which java-1.8.0-openjdk-devel" && \
      yum clean all && yum-config-manager --disable \* &> /dev/null && \
      ### Add necessary Red Hat repos here
      yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
      yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
      cd /tmp && \
      wget https://www.tremolosecurity.com/dwn/tremolosecurity-downloads/unison/${UNISON_VERSION}/tremolo-service-${UNISON_VERSION}.tar.gz && \
      tar -xvzf tremolo-service-${UNISON_VERSION}.tar.gz && \
      groupadd -r tremoloadmin -g 433 && \
      useradd  -u 431 -r -g tremoloadmin -d /usr/local/tremolo/tremolo-service -s /sbin/nologin -c "Unison Docker image user" tremoloadmin && \
      mkdir -p /usr/local/tremolo/tremolo-service && \
      mv /tmp/tremolo-service-${UNISON_VERSION}/* /usr/local/tremolo/tremolo-service && \
      rm -rf /tmp/tremolo-service-* && \
      rm /usr/local/tremolo/tremolo-service/conf/log4j2.xml && \
      mv /tmp/log4j2.xml /usr/local/tremolo/tremolo-service/conf/ && \
      mkdir /tmp/drivers && \
      cd /tmp/drivers && \
      curl -L -O https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}.jar && \
      curl -L -O https://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/${PGSQL_JDBC_VERSION}/postgresql-${PGSQL_JDBC_VERSION}.jar && \
      mkdir /usr/local/tremolo/tremolo-service/external && \
      mv /tmp/firstStart.sh /usr/local/tremolo/tremolo-service/bin/ && \
      mv /tmp/startUnisonInDocker.sh /usr/local/tremolo/tremolo-service/bin/ && \
      chmod +x /usr/local/tremolo/tremolo-service/bin/startUnisonInDocker.sh && \
      chmod +x /usr/local/tremolo/tremolo-service/bin/firstStart.sh && \
      chown -R tremoloadmin:tremoloadmin /usr/local/tremolo && \
      chmod -R ugo+rw /usr/local/tremolo && \
      chmod -R ugo+rw /tmp/drivers && \
      go-md2man -in /tmp/help.md -out /help.1 && \
      yum -y remove golang-github-cpuguy83-go-md2man && \
      rm -rf /var/cache/yum



VOLUME /usr/local/tremolo/tremolo-service/external


USER 431
WORKDIR /usr/local/tremolo/tremolo-service
ENV JAVA_OPTS -XX:+UseParallelGC  -Djava.security.egd=file:/dev/./urandom

#This gives me an error
#HEALTHCHECK CMD curl --insecure -v https://localhost:9090/ 2>&1 | grep subject  || exit 1

CMD /usr/local/tremolo/tremolo-service/bin/firstStart.sh
