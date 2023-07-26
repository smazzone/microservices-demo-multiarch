
FROM openjdk:18-jdk-alpine

#RUN mvn clean install -Dmaven.test.skip=true

COPY target/paymentservicejava-0.0.1-SNAPSHOT.jar paymentservice.jar

RUN wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer
 
# Datadog - Enable tracer
ENV DD_PROFILING_ENABLED=true
ENV DD_LOGS_INJECTION=true
 
ENV JAVA_OPTS=-javaagent:dd-java-agent.jar

ENTRYPOINT ["java","-jar","/paymentservice.jar"]
EXPOSE 9090
