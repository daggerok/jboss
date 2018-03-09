FROM openjdk:8u151-jdk-alpine
MAINTAINER Maksim Kostromin https://github.com/daggerok

ARG JBOSS_USER_ARG="jboss-wildfly"
ARG JBOSS_ADMIN_USER_ARG="admin"
ARG JBOSS_ADMIN_PASSWORD_ARG="Admin.123"
ARG JBOSS_WILDFLY_VERSION_ARG="12.0.0.Final"
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

############################################## USAGE ################################################
# FROM daggerok/jboss:wildfly-12.0.0.Final-alpine                                                   #
# HEALTHCHECK --timeout=2s --retries=22 \                                                           #
#         CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \                        #
#          || exit 1                                                                                #
# COPY --chown=jboss-wildfly ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war #
#####################################################################################################

################################ DEBUG | MULTI-DEPLOYMENTS USAGE ####################################
# FROM daggerok/jboss:wildfly-12.0.0.Final                                                          #
# # Debug:                                                                                          #
# ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"     #
# EXPOSE 5005                                                                                       #
# # Multi builds:                                                                                   #
# COPY --chown=jboss-wildfly ./path/to/app.ear ./target/*.war ${JBOSS_HOME}/standalone/deployments/ #
#####################################################################################################
