# jboss [![Build Status](https://travis-ci.org/daggerok/jboss.svg?branch=master)](https://travis-ci.org/daggerok/jboss)
JBOSS WildFly 10.1.0.Final docker image (Linux Alpine, OpenJDK 8u151)

**Exposed ports**:

- 8080 - deployed apps http port
- 9990 - console port
- 8443 - https port

**Console**:

- url: http://127.0.0.1:9990/console
- user: admin
- password: Admin.123

### Usage (with healthcheck):

```

FROM daggerok/jboss:wildfly-10.1.0.Final
ADD ./build/libs/*.war ${JBOSS_HOME}/standalone/deployments/

```

#### Remote debug / multi-build deployment:

```

FROM daggerok/jboss:wildfly-10.1.0.Final-alpine
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 \"" >> ${JBOSS_HOME}/bin/standalone.conf
EXPOSE 5005
COPY ./build/libs/*.war ./target/*.ear ${JBOSS_HOME}/standalone/deployments/

```
