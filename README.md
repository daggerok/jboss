# JBOSS [![Build Status](https://travis-ci.org/daggerok/jboss.svg?branch=master)](https://travis-ci.org/daggerok/jboss)
automated build for docker hub

## JBOSS EAP / WildFly
based on `openjdk:8u151-jdk-alpine` image

tags:

- [eap-7.1-full-ha](https://github.com/daggerok/jboss/blob/eap-7.1-full-ha/Dockerfile)
- [eap-7.1-full](https://github.com/daggerok/jboss/blob/eap-7.1-full/Dockerfile)
- [eap-7.1](https://github.com/daggerok/jboss/blob/eap-7.1/Dockerfile)
- [eap-7.0](https://github.com/daggerok/jboss/blob/eap-7.0/Dockerfile)
- [eap-6.4](https://github.com/daggerok/jboss/blob/eap-6.4/Dockerfile)
- [eap-6.3](https://github.com/daggerok/jboss/blob/eap-6.3/Dockerfile)
- [eap-6.2](https://github.com/daggerok/jboss/blob/eap-6.2/Dockerfile)
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

- [7.1.1.Final](https://github.com/daggerok/jboss/blob/7.1.1.Final/Dockerfile)

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

## JBOSS AS (OUTDATED / DEPRECATED / NOT RECOMMENDED FOR USE)

tags:

- [6.1.0.Final](https://github.com/daggerok/jboss/blob/6.1.0.Final/Dockerfile)
- [5.1.0.GA](https://github.com/daggerok/jboss/blob/5.1.0.GA/Dockerfile)
- [4.2.3.GA](https://github.com/daggerok/jboss/blob/4.2.3.GA/Dockerfile)
- [4.2.3.GA-java1.5 (based on `lwis/java5` image)](https://github.com/daggerok/jboss/blob/4.2.3.GA-java1.5/Dockerfile)
- [4.2.2.GA](https://github.com/daggerok/jboss/blob/4.2.2.GA/Dockerfile)

**Exposed ports**:

- 8080 - HTTP port
- 1009 - JNDI port
- 8009 - AJP 1.3 Connector port
- 8083 - RMI WebService port
- 8093 - MBean port

### Usage 

#### health-check

```

FROM daggerok/jboss:5.1.0.Final
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/api/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/server/default/deploy/my-service.war

```

#### remote debug

```

FROM daggerok/jboss:4.2.3.GA-java1.5
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/server/default/deploy/

```

#### multi-build deployment:

```

FROM daggerok/jboss:4.2.2.GA
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/server/default/deploy/

```
