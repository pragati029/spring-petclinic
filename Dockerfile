FROM maven:3.9.11-eclipse-temurin-17 AS build
ENV BUILD_ENV=DEV
WORKDIR /app
ADD spring-petclinic ./spring-petclinic
RUN mvn -f spring-petclinic/pom.xml package -DskipTests

FROM openjdk:17-jdk-alpine AS runtime
ARG APP_USER=demouser
ARG APP_DIR=/usr/share/demo
ENV RUNTIME_ENV=PROD
RUN adduser -D -h ${APP_DIR} -s /bin/bash ${APP_USER}
USER ${APP_USER}
WORKDIR ${APP_DIR}
COPY --from=build /app/spring-petclinic/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar"]
CMD ["app.jar"]
