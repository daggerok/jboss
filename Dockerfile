# git clone https://github.com/daggerok/jboss
# docker build -t daggerok/jboss -f jboss/Dockerfile .
# docker tag daggerok/jboss daggerok/jboss:alpine
# docker tag daggerok/jboss daggerok/jboss:latest
# docker push daggerok/jboss

FROM openjdk:8u151-jdk-alpine
MAINTAINER Maksim Kostromin https://github.com/daggerok

ARG JBOSS_USER="jboss-eap-6.4"
ARG DROPBOX_HASH_ARG="xl2io9dhc6zxw9m"
ARG JBOSS_FILE_ARG="jboss-eap-6.4.0.zip"
ARG JBOSS_ADMIN_USER_ARG="admin"
ARG JBOSS_ADMIN_PASSWORD_ARG="Admin.123"

ENV DROPBOX_HASH=${DROPBOX_HASH_ARG} \
    JBOSS_FILE=${JBOSS_FILE_ARG}
ENV JBOSS_URL="https://www.dropbox.com/s/${DROPBOX_HASH}/${JBOSS_FILE}" \
    JBOSS_ADMIN_PASSWORD=${JBOSS_ADMIN_PASSWORD_ARG} \
    JBOSS_ADMIN_USER=${JBOSS_ADMIN_USER_ARG} \
    JBOSS_USER_HOME="/home/${JBOSS_USER}"
ENV JBOSS_HOME="${JBOSS_USER_HOME}/${JBOSS_USER}"

RUN apk --no-cache --update add busybox-suid bash wget ca-certificates unzip sudo openssh-client shadow \
 && addgroup ${JBOSS_USER}-group \
 && echo "${JBOSS_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && sed -i "s/.*requiretty$/Defaults !requiretty/" /etc/sudoers \
 && adduser -h ${JBOSS_USER_HOME} -s /bin/bash -D -u 1025 ${JBOSS_USER} ${JBOSS_USER}-group \
 && usermod -a -G wheel ${JBOSS_USER} \
 && apk --no-cache --no-network --purge del busybox-suid ca-certificates unzip shadow \
 && rm -rf /var/cache/apk/* /tmp/*

USER ${JBOSS_USER}
WORKDIR ${JBOSS_USER_HOME}

CMD /bin/bash
EXPOSE 8080 9990 8443
ENTRYPOINT /bin/bash ${JBOSS_HOME}/bin/standalone.sh

RUN wget ${JBOSS_URL} -O ${JBOSS_USER_HOME}/${JBOSS_FILE} \
 && unzip ${JBOSS_USER_HOME}/${JBOSS_FILE} -d ${JBOSS_USER_HOME} \
 && rm -rf ${JBOSS_USER_HOME}/${JBOSS_FILE} \
 && ${JBOSS_HOME}/bin/add-user.sh ${JBOSS_ADMIN_USER} ${JBOSS_ADMIN_PASSWORD} --silent \
 && echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> ${JBOSS_HOME}/bin/standalone.conf

############################################ USAGE ##############################################
# FROM daggerok/jboss:jboss-eap-6.4                                                             #
# HEALTHCHECK --timeout=2s --retries=22 \                                                       #
#         CMD wget -q --spider http://127.0.0.1:8080/my-service/health \                        #
#          || exit 1                                                                            #
# COPY --chown=jboss ./target/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war         #
#################################################################################################

############################## DEBUG | MULTI-DEPLOYMENTS USAGE ##################################
# FROM daggerok/jboss:jboss-eap-6.4                                                             #
# # Debug:                                                                                      #
# ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" #
# EXPOSE 5005                                                                                   #
# # Multi builds:                                                                               #
# COPY --chown=jboss ./target/*.war ${JBOSS_HOME}/standalone/deployments/                       #
#################################################################################################

