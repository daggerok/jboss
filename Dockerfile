FROM openjdk:8u191-jdk-alpine3.8
LABEL MAINTAINER='Maksim Kostromin https://github.com/daggerok'

ARG VERSION_ARG='7.2'
ARG JBOSS_ADMIN_USER_ARG='admin'
ARG JBOSS_ADMIN_PASSWORD_ARG='Admin.123'

ENV VERSION=${VERSION_ARG} \
    JBOSS_ADMIN_USER=${JBOSS_ADMIN_USER_ARG} \
    JBOSS_ADMIN_PASSWORD=${JBOSS_ADMIN_PASSWORD_ARG}

ENV JBOSS_USER='jboss' \
    JBOSS_FOLDER="jboss-eap-${VERSION}"

ENV JBOSS_FILE="${JBOSS_FOLDER}.0.zip" \
    JBOSS_USER_HOME="/home/${JBOSS_USER}"

ENV JBOSS_URL="https://github.com/daggerok/jboss/releases/download/eap/${JBOSS_FILE}"                   \
    JBOSS_HOME="${JBOSS_USER_HOME}/${JBOSS_FOLDER}"

RUN apk add --no-cache --update busybox-suid bash wget ca-certificates unzip sudo openssh-client shadow \
 && addgroup ${JBOSS_USER}-group                                                                        \
 && echo "${JBOSS_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers                                        \
 && sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers                                         \
 && adduser -h ${JBOSS_USER_HOME} -s /bin/bash -D -u 1025 ${JBOSS_USER} ${JBOSS_USER}-group             \
 && usermod -a -G wheel ${JBOSS_USER}                                                                   \
 && wget --no-cookies                                                                                   \
         --no-check-certificate                                                                         \
         --header 'Cookie: oraclelicense=accept-securebackup-cookie'                                    \
                  'http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip'                      \
         -O /tmp/jce_policy-8.zip                                                                       \
 && unzip -o /tmp/jce_policy-8.zip -d /tmp                                                              \
 && mv -f ${JAVA_HOME}/lib/security ${JAVA_HOME}/lib/backup-security || true                            \
 && mv -f /tmp/UnlimitedJCEPolicyJDK8 ${JAVA_HOME}/lib/security      || true

USER ${JBOSS_USER}
WORKDIR ${JBOSS_USER_HOME}

ARG JAVA_OPTS_ARGS=' \
 -Djava.net.preferIPv4Stack=true \
 -XX:+UnlockExperimentalVMOptions \
 -XX:+UseCGroupMemoryLimitForHeap \
 -XshowSettings:vm '

ENV JAVA_OPTS="${JAVA_OPTS} ${JAVA_OPTS_ARGS}"

CMD /bin/ash
EXPOSE 8080 9990 8443
ENTRYPOINT /bin/bash ${JBOSS_HOME}/bin/standalone.sh

RUN wget -q ${JBOSS_URL} -O ${JBOSS_USER_HOME}/${JBOSS_FILE}                                            \
 && unzip ${JBOSS_USER_HOME}/${JBOSS_FILE} -d ${JBOSS_USER_HOME}                                        \
 && rm -rf ${JBOSS_USER_HOME}/${JBOSS_FILE}                                                             \
 && sudo apk del --no-cache --no-network --purge busybox-suid unzip shadow                              \
 && ( sudo rm -rf /var/cache/apk/* /tmp/* || true )                                                     \
 && ${JBOSS_HOME}/bin/add-user.sh ${JBOSS_ADMIN_USER} ${JBOSS_ADMIN_PASSWORD} --silent                  \
 && echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> ${JBOSS_HOME}/bin/standalone.conf

########################################## USAGE ################################################
# FROM daggerok/jboss:eap-7.2-alpine                                                            #
# COPY --chown=jboss ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war     #
#################################################################################################

####################################### HEALTHCHECK #############################################
# FROM daggerok/jboss:eap-7.2                                                                   #
# HEALTHCHECK --timeout=2s --retries=22 \                                                       #
#         CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \                    #
#          || exit 1                                                                            #
# ...                                                                                           #
#################################################################################################

################################### MULTI-DEPLOYMENTS ###########################################
# FROM daggerok/jboss:eap-7.2-alpine                                                            #
# ...                                                                                           #
# COPY --chown=jboss ./path/to/app.ear ./target/*.war ${JBOSS_HOME}/standalone/deployments/     #
#################################################################################################

######################################## DEBUG ##################################################
# FROM daggerok/jboss:eap-7.2                                                                   #
# ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" #
# EXPOSE 5005                                                                                   #
# ...                                                                                           #
#################################################################################################
