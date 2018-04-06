# JBOSS [![Build Status](https://travis-ci.org/daggerok/jboss.svg?branch=master)](https://travis-ci.org/daggerok/jboss)
automated build for docker hub

## JBOSS EAP / WildFly
based on `openjdk:8u151-jdk-alpine` image

tags:

- [eap-7.1-full-ha](https://github.com/daggerok/jboss/blob/eap-7.1-full-ha/Dockerfile)
- [eap-7.1-full](https://github.com/daggerok/jboss/blob/eap-7.1-full/Dockerfile)
- [eap-7.1](https://github.com/daggerok/jboss/blob/eap-7.1/Dockerfile)
- [eap-6.4](https://github.com/daggerok/jboss/blob/eap-6.4/Dockerfile)
- [eap-6.1](https://github.com/daggerok/jboss/blob/eap-6.1/Dockerfile)

- [wildfly-12.0.0.Final](https://github.com/daggerok/jboss/blob/wildfly-12.0.0.Final/Dockerfile)
- [wildfly-11.0.0.Final](https://github.com/daggerok/jboss/blob/wildfly-11.0.0.Final/Dockerfile)
- [wildfly-10.1.0.Final](https://github.com/daggerok/jboss/blob/wildfly-10.1.0.Final/Dockerfile)
- [wildfly-10.0.0.Final](https://github.com/daggerok/jboss/blob/wildfly-10.0.0.Final/Dockerfile)
- [wildfly-9.0.2.Final](https://github.com/daggerok/jboss/blob/wildfly-9.0.2.Final/Dockerfile)
- [wildfly-9.0.1.Final](https://github.com/daggerok/jboss/blob/wildfly-9.0.1.Final/Dockerfile)
- [wildfly-9.0.0.Final](https://github.com/daggerok/jboss/blob/wildfly-9.0.0.Final/Dockerfile)
- [wildfly-8.2.0.Final](https://github.com/daggerok/jboss/blob/wildfly-8.2.0.Final/Dockerfile)
- [wildfly-8.1.0.Final](https://github.com/daggerok/jboss/blob/wildfly-8.1.0.Final/Dockerfile)
- [wildfly-8.0.0.Final](https://github.com/daggerok/jboss/blob/wildfly-8.0.0.Final/Dockerfile)

- [latest](https://github.com/daggerok/jboss/blob/master/Dockerfile)

**Exposed ports**:

- 8080 - web applications
- 9990 - management console
- 8443 - https

### Usage

#### health-check

```

FROM daggerok/jboss:eap-7.1
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war

```

#### remote debug

```

FROM daggerok/jboss:eap-6.4
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
ADD ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war

```

#### multi-build deployment:

```

FROM daggerok/jboss:wildfly-12.0.0.Final
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/standalone/deployments/

```

## JBOSS 5.1.0.Final

**Exposed ports**:

- 8080 - HTTP port
- 1009 - JNDI port
- 8009 - AJP 1.3 Connector port
- 8083 - RMI WebService port
- 8093 - MBean port

### Usage (with healthcheck):

```

FROM daggerok/jboss:5.1.0.Final
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/server/default/deploy/my-service.war

```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss:5.1.0.Final
# Remote debug:
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
# Multi-builds deployment:
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/server/default/deploy/

```

## JBOSS 4.2.3.GA
**tags**:

- 4.2.3.GA based on `openjdk:8u151-jre-alpine3.7` image
- 4.2.3.GA-java1.5 based on `lwis/java5` image

**Exposed ports**:

- 8080 - HTTP port
- 1009 - JNDI port
- 8009 - AJP 1.3 Connector port
- 8083 - RMI WebService port
- 8093 - MBean port

### Usage (with healthcheck):

```

FROM daggerok/jboss:4.2.2.GA-java1.5
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/server/default/deploy/my-service.war

```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss:4.2.3.GA
# Remote debug:
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
# Multi-builds deployment:
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/server/default/deploy/

```

## JBOSS 4.2.2.GA
based on `openjdk:8u151-jre-alpine3.7` image

**Exposed ports**:

- 8080 - HTTP port
- 1009 - JNDI port
- 8009 - AJP 1.3 Connector port
- 8083 - RMI WebService port
- 8093 - MBean port

### Usage (with healthcheck):

```

FROM daggerok/jboss:4.2.2.GA
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/server/default/deploy/my-service.war

```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss:4.2.2.GA
# Remote debug:
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
# Multi-builds deployment:
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/server/default/deploy/

```
