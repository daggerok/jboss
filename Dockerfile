# git clone https://github.com/daggerok/jboss-wildfly
# docker build -t daggerok/jboss-wildfly -f jboss-wildfly/Dockerfile .
# docker tag daggerok/jboss-wildfly daggerok/jboss-wildfly:8.2.0.Final-alpine
# docker tag daggerok/jboss-wildfly daggerok/jboss-wildfly:8.2.0.Final
# docker tag daggerok/jboss-wildfly daggerok/jboss-wildfly:alpine
# docker tag daggerok/jboss-wildfly daggerok/jboss-wildfly:latest
# docker push daggerok/jboss-wildfly

FROM openjdk:8u151-jdk-alpine
MAINTAINER Maksim Kostromin https://github.com/daggerok/docker

ARG JBOSS_USER_ARG="jboss-wildfly"
ARG JBOSS_ADMIN_USER_ARG="admin"
ARG JBOSS_ADMIN_PASSWORD_ARG="Admin.123"
ARG JBOSS_WILDFLY_VERSION_ARG="8.2.0.Final"
#ARG JBOSS_WILDFLY_VERSION_ARG="8.2.1.Final"
##ARG JBOSS_WILDFLY_VERSION_ARG="9.0.0.Final"
##ARG JBOSS_WILDFLY_VERSION_ARG="9.0.1.Final"
###ARG JBOSS_WILDFLY_VERSION_ARG="9.0.2.Final"
####ARG JBOSS_WILDFLY_VERSION_ARG="10.0.0.Final"
#####ARG JBOSS_WILDFLY_VERSION_ARG="10.1.0.Final"
######ARG JBOSS_WILDFLY_VERSION_ARG="11.0.0.Final"
ARG JBOSS_WILDFLY_FILE_ARG="wildfly-${JBOSS_WILDFLY_VERSION_ARG}"

ENV JBOSS_USER=${JBOSS_USER_ARG} \
    JBOSS_ADMIN_USER=${JBOSS_ADMIN_USER_ARG} \
    JBOSS_ADMIN_PASSWORD=${JBOSS_ADMIN_PASSWORD_ARG} \
    JBOSS_WILDFLY_VERSION=${JBOSS_WILDFLY_VERSION_ARG} \
    JBOSS_WILDFLY_FILE=${JBOSS_WILDFLY_FILE_ARG}
ENV JBOSS_URL="http://download.jboss.org/wildfly/${JBOSS_WILDFLY_VERSION}/${JBOSS_WILDFLY_FILE}.zip" \
    JBOSS_USER_HOME="/home/${JBOSS_USER}"
ENV JBOSS_HOME="${JBOSS_USER_HOME}/${JBOSS_WILDFLY_FILE}"

RUN apk --no-cache --update add busybox-suid bash wget ca-certificates unzip sudo openssh-client shadow \
 && addgroup ${JBOSS_USER}-group \
 && echo "${JBOSS_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && sed -i "s/.*requiretty$/Defaults !requiretty/" /etc/sudoers \
 && adduser -h ${JBOSS_USER_HOME} -s /bin/bash -D -u 1025 ${JBOSS_USER} ${JBOSS_USER}-group \
 && usermod -a -G wheel ${JBOSS_USER} \
 && apk --no-cache --no-network --purge del busybox-suid shadow \
 && rm -rf /var/cache/apk/* /tmp/*

USER ${JBOSS_USER}
WORKDIR ${JBOSS_USER_HOME}

CMD /bin/bash
EXPOSE 8080 9990 8443
ENTRYPOINT /bin/bash ${JBOSS_HOME}/bin/standalone.sh

RUN wget ${JBOSS_URL} -O "${JBOSS_USER_HOME}/${JBOSS_WILDFLY_FILE}.zip" \
 && unzip "${JBOSS_USER_HOME}/${JBOSS_WILDFLY_FILE}.zip" -d ${JBOSS_USER_HOME} \
 && rm -rf "${JBOSS_USER_HOME}/${JBOSS_WILDFLY_FILE}.zip" \
 && ${JBOSS_HOME}/bin/add-user.sh ${JBOSS_ADMIN_USER} ${JBOSS_ADMIN_PASSWORD} --silent \
 && echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> ${JBOSS_HOME}/bin/standalone.conf

## check all apps healthy (in current example we are expecting to have apps with /ui/ and /rest-api/ contexts deployed:
#HEALTHCHECK --interval=1s --timeout=3s --retries=30 \
# CMD wget -q --spider http://127.0.0.1:8080/rest-api/health \
#  && wget -q --spider http://127.0.0.1:8080/ui/ \
#  || exit 1
#
## deploy apps
#COPY ./path/to/*.war ./path/to/another/*.war ${JBOSS_HOME}/standalone/deployments/
