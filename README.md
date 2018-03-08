# jboss4-java5 [![Build Status](https://travis-ci.org/daggerok/jboss4-java5.svg?branch=master)](https://travis-ci.org/daggerok/jboss4-java5)
JBOSS 4 automation build for docker hub (based on docker image `lwis/java5` with preinstalled java 1.5)

**Exposed ports**:

- 8080 - deployed apps

### Usage:

```

FROM daggerok/jboss4-java5
ADD ./build/libs/*.war ${JBOSS_HOME}/default/deploy/
```

#### Remote debug:

```

FROM daggerok/jboss4-java5
ENV JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 "
EXPOSE 5005
COPY ./build/libs/*.war ./target/*.ear ${JBOSS_HOME}/default/deploy/
```

