FROM openjdk:8u151-jre-alpine3.7
MAINTAINER Maksim Kostromin https://github.com/daggerok
ARG JBOSS_VERSION_ARG="4.2.3.GA"
ENV JBOSS_VERSION="${JBOSS_VERSION_ARG}"
ENV JBOSS_HOME="/opt/jboss-${JBOSS_VERSION}"
RUN apk --no-cache --update add bash curl unzip wget \
 && wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
                  "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
         -O /tmp/jce_policy-8.zip \
 && unzip -o /tmp/jce_policy-8.zip -d /tmp \
 && mv -f ${JAVA_HOME}/lib/security ${JAVA_HOME}/lib/backup-security \
 && mv -f /tmp/UnlimitedJCEPolicyJDK8 ${JAVA_HOME}/lib/security \
 && wget --no-check-certificate \
             -O /tmp/jboss-${JBOSS_VERSION}.zip \
             https://sourceforge.net/projects/jboss/files/JBoss/JBoss-${JBOSS_VERSION}/jboss-${JBOSS_VERSION}.zip \
 && unzip -d /opt /tmp/jboss-${JBOSS_VERSION}.zip \
 && apk del unzip \
 && rm -rf /var/cache/apk/* /tmp/*
EXPOSE 1009 8080 8009 8083 8093
CMD /bin/bash
ENTRYPOINT chmod +x ${JBOSS_HOME}/bin/run.sh \
                 && ${JBOSS_HOME}/bin/run.sh -b 0.0.0.0

############################################ USAGE ##############################################
# FROM daggerok/jboss:4.2.3.GA                                                                  #
# HEALTHCHECK --timeout=2s --retries=22 \                                                       #
#         CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \                    #
#          || exit 1                                                                            #
# COPY ./target/*.war ${JBOSS_HOME}/server/default/deploy/my-service.war                        #
#################################################################################################

############################## DEBUG | MULTI-DEPLOYMENTS USAGE ##################################
# FROM daggerok/jboss:4.2.3.GA                                                                  #
# # Debug:                                                                                      #
# ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" #
# EXPOSE 5005                                                                                   #
# # Multi builds:                                                                               #
# COPY ./target/*.war ./build/libs/other.war ${JBOSS_HOME}/server/default/deploy/               #
#################################################################################################

