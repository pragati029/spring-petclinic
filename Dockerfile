FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /myapp
ADD . /myapp
RUN mvn package

FROM eclipse-temurin:17.0.16_8-jre-noble AS runtime
ARG USER=Sujan
ARG DIR=/usr/share/web
LABEL project="javaproject"
LABEL env="prod"
RUN useradd -m -d ${DIR} -s /bin/sh ${USER}
USER ${USER}
WORKDIR ${DIR}
COPY --from=build /myapp/target/*.jar *.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar"]
CMD ["*.jar"]
