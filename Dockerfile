# Multi-stage build for Java microservice with WildFly

# Stage 1: Build the application
FROM maven:3.8.6-openjdk-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy to WildFly
FROM jboss/wildfly:26.1.3.Final

# Copy the WAR file to WildFly deployments directory
COPY --from=build /app/target/microservice.war /opt/jboss/wildfly/standalone/deployments/

# Expose ports
EXPOSE 8080 9990

# Start WildFly
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
