FROM openjdk:latest
COPY target/myapp.jar /opt
EXPOSE 8080
CMD java -jar /opt/myapp.jar