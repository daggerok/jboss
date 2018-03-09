# jboss [![Build Status](https://travis-ci.org/daggerok/jboss.svg?branch=master)](https://travis-ci.org/daggerok/jboss)
JBOSS EAP 6.4 automation build for docker hub (based on `openjdk:8u151-jdk-alpine` image

**Exposed ports**:

- 8080 - deployed apps http port
- 8009, 8083, 8093 - who cares ports...

### Usage (with healthcheck):

```

FROM daggerok/jboss:jboss-eap-6.4
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/my-service.war

```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss:jboss-eap-6.4
# Remote debug:
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
# Multi-builds deployment:
COPY ./build/libs/*.war ./target/*.war ${JBOSS_HOME}/standalone/deployments/

```

