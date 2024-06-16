FROM openjdk:17-jdk-slim as builder

# set arg
ARG WORKSPACE=./
ARG BUILD_TARGET=${WORKSPACE}/build/libs
WORKDIR ${WORKSPACE}

## copy code & build
#COPY . .
#RUN chmod +x ./gradlew
#RUN ./gradlew clean bootJar

#COPY ${BUILD_TARGET}/*.jar app.jar
COPY ./build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]