# jboss4 [![Build Status](https://travis-ci.org/daggerok/jboss4.svg?branch=master)](https://travis-ci.org/daggerok/jboss4)
JBOSS 4 automation build for docker hub based on `openjdk:8u151-jre-alpine3.7` image

**Exposed ports**:

- 8080 - deployed apps
- 8009, 8083, 8093

### Usage (with healthcheck):

```

FROM daggerok/jboss4:root
HEALTHCHECK --timeout=2s --retries=22 \
        CMD wget -q --spider http://127.0.0.1:8080/my-service/health \
         || exit 1
ADD ./build/libs/*.war ${JBOSS_HOME}/default/deploy/my-service.war
```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss4:root
# Remote debug:
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
# Multi-builds deployment:
COPY ./build/libs/*.war ./target/*.ear ${JBOSS_HOME}/default/deploy/
```

