FROM openjdk:17-jdk-slim
RUN mkdir /app
COPY ./demo*.jar ./app/demo.jar
WORKDIR /app

EXPOSE 8089
CMD ["java", "-jar", "demo.jar"]