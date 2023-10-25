# Brad: I'm commenting this out to test a few things. Need a proper shell with utilities and everything. We can always change this back later.
#FROM openjdk:17-jdk-alpine
FROM ubuntu:20.04 

#RUN mvn clean install -Dmaven.test.skip=true

# Brad: I'm also installing the utilities I need to debug some database issues I discovered. Need to comment out before we push this to production
RUN apt-get update
RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -y mariadb-client
RUN apt-get install -y wget
RUN apt-get install -y curl vim
# Brad: I'm adding this to debug
RUN apt-get -y install sudo

RUN mkdir /app

COPY releases/paymentservicejava-0.5.0-vulnerable.jar /app/paymentservice.jar

WORKDIR /app
RUN wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer
 
# Datadog - Enable tracer
ENV DD_PROFILING_ENABLED=true
ENV DD_LOGS_INJECTION=true
 
ENV JAVA_OPTS=-javaagent:dd-java-agent.jar

WORKDIR /app
ENTRYPOINT ["java","-jar","/app/paymentservice.jar"]
EXPOSE 9090
