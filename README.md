# jboss4-java5 [![Build Status](https://travis-ci.org/daggerok/jboss4-java5.svg?branch=master)](https://travis-ci.org/daggerok/jboss4-java5)
JBOSS 4 automation build for docker hub (based on docker image `lwis/java5` with preinstalled java 1.5)

**Exposed ports**:

- 8080 - deployed apps

### Usage:

```

FROM daggerok/jboss4-java5:v2
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/default/deploy/my-service.war
```

#### Remote debug:

```

FROM daggerok/jboss4-java5
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
COPY ./build/libs/*.war ./target/*.ear ${JBOSS_HOME}/default/deploy/
```

