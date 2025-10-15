FROM maven:3.9.11-eclipse-temurin-17 AS build
ADD . /app
WORKDIR /app
RUN mvn clean package

FROM eclipse-temurin:25_36-jre-noble AS runtime
LABEL project="java_project"
LABEL environment="prod"
ENV JAVA_HOME=/usr/lib/jvm/openjdk-17-jdk-amd64
ENV MAVEN_HOME=/jami/
ARG myuser=devops
ARG homedir=/usr/share/manoj
RUN useradd -m -d ${homedir} -s /bin/sh ${myuser}
USER ${myuser}
COPY --from=build /app/target/*.jar /devops/kumar.jar
WORKDIR /devops
EXPOSE 8080
CMD ["java", "-jar", "kumar.jar"]
