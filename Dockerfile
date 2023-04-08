FROM openjdk:17-jdk-alpine3.14
WORKDIR /app
COPY ./target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]