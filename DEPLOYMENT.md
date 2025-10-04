# Deployment Guide

This guide covers different deployment options for the Spring Boot microservice.

## Table of Contents

1. [Local Development](#local-development)
2. [Docker Deployment](#docker-deployment)
3. [WildFly Deployment](#wildfly-deployment)
4. [Jenkins CI/CD](#jenkins-cicd)
5. [Production Considerations](#production-considerations)

---

## Local Development

### Prerequisites

- Java 17 or higher
- Maven 3.6+

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rbib-dev/java-project.git
   cd java-project
   ```

2. **Build the project:**
   ```bash
   mvn clean package
   ```

3. **Run the application:**
   ```bash
   mvn spring-boot:run
   ```

4. **Access the application:**
   - API: http://localhost:8080/microservice/api/hello
   - Health: http://localhost:8080/microservice/actuator/health

---

## Docker Deployment

### Prerequisites

- Docker 20.10+
- Docker Compose 2.0+

### Using Docker Build

1. **Build the Docker image:**
   ```bash
   docker build -t microservice:latest .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     -p 8080:8080 \
     -p 9990:9990 \
     --name microservice \
     microservice:latest
   ```

3. **View logs:**
   ```bash
   docker logs -f microservice
   ```

4. **Stop the container:**
   ```bash
   docker stop microservice
   docker rm microservice
   ```

### Using Docker Compose

1. **Start the service:**
   ```bash
   docker-compose up -d
   ```

2. **View logs:**
   ```bash
   docker-compose logs -f
   ```

3. **Stop the service:**
   ```bash
   docker-compose down
   ```

4. **Rebuild and restart:**
   ```bash
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

---

## WildFly Deployment

### Manual Deployment

1. **Build the WAR file:**
   ```bash
   mvn clean package
   ```

2. **Copy to WildFly:**
   ```bash
   cp target/microservice.war $WILDFLY_HOME/standalone/deployments/
   ```

3. **Start WildFly:**
   ```bash
   $WILDFLY_HOME/bin/standalone.sh
   ```

4. **Access the application:**
   - Application: http://localhost:8080/microservice
   - Admin Console: http://localhost:9990

### Docker WildFly Deployment

The Dockerfile uses WildFly as the application server. The multi-stage build:

1. **Build stage:** Compiles and packages the application with Maven
2. **Runtime stage:** Deploys the WAR to WildFly

The container automatically:
- Deploys the WAR file to WildFly
- Exposes ports 8080 (HTTP) and 9990 (Management)
- Starts WildFly in standalone mode

---

## Jenkins CI/CD

### Jenkins Setup

1. **Install Jenkins:**
   ```bash
   # Using Docker
   docker run -d \
     -p 8081:8080 \
     -p 50000:50000 \
     -v jenkins_home:/var/jenkins_home \
     jenkins/jenkins:lts
   ```

2. **Install Required Plugins:**
   - Pipeline
   - Docker Pipeline
   - Maven Integration
   - JUnit
   - Git

3. **Configure Tools:**
   - Go to: Manage Jenkins → Global Tool Configuration
   - Add Maven 3.8.6 (or higher)
   - Add JDK 17

### Pipeline Configuration

1. **Create New Pipeline Job:**
   - New Item → Pipeline
   - Name: microservice-pipeline

2. **Configure SCM:**
   - Pipeline Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: https://github.com/rbib-dev/java-project.git
   - Script Path: Jenkinsfile

3. **Run the Pipeline:**
   - Click "Build Now"
   - Monitor the pipeline stages

### Pipeline Stages

The Jenkinsfile includes these stages:

1. **Checkout:** Clones the repository
2. **Build:** Compiles the code
3. **Test:** Runs unit tests
4. **Package:** Creates the WAR file
5. **Code Analysis:** Runs verification
6. **Build Docker Image:** Creates Docker image
7. **Push Docker Image:** Pushes to registry (main branch only)
8. **Deploy:** Deploys the application (main branch only)

---

## Production Considerations

### Security

1. **Update Default Passwords:**
   - WildFly admin console
   - Database credentials
   - Docker registry credentials

2. **Enable HTTPS:**
   - Configure SSL certificates
   - Update application.properties
   - Configure reverse proxy (Nginx/Apache)

3. **Secure Actuator Endpoints:**
   ```properties
   management.endpoints.web.exposure.include=health,info
   management.endpoint.health.show-details=when-authorized
   spring.security.user.name=admin
   spring.security.user.password=<secure-password>
   ```

### Performance

1. **JVM Options:**
   ```bash
   export JAVA_OPTS="-Xms1024m -Xmx2048m -XX:MetaspaceSize=256m"
   ```

2. **Connection Pooling:**
   - Configure Hikari CP for database connections
   - Tune thread pool sizes

3. **Caching:**
   - Enable Spring Cache
   - Configure Redis or similar

### Monitoring

1. **Application Metrics:**
   - Enable all actuator endpoints
   - Integrate with Prometheus
   - Setup Grafana dashboards

2. **Logging:**
   - Configure centralized logging (ELK Stack)
   - Set appropriate log levels
   - Enable log rotation

3. **Health Checks:**
   - Configure readiness probes
   - Configure liveness probes
   - Set up alerting

### High Availability

1. **Load Balancing:**
   - Deploy multiple instances
   - Configure Nginx/HAProxy
   - Enable session replication

2. **Database:**
   - Use production-grade database
   - Configure replication
   - Setup regular backups

3. **Container Orchestration:**
   - Deploy to Kubernetes
   - Configure auto-scaling
   - Setup rolling updates

### Environment Configuration

1. **Development:**
   ```properties
   spring.profiles.active=dev
   logging.level.com.example=DEBUG
   ```

2. **Staging:**
   ```properties
   spring.profiles.active=staging
   logging.level.com.example=INFO
   ```

3. **Production:**
   ```properties
   spring.profiles.active=prod
   logging.level.com.example=WARN
   ```

### Backup and Recovery

1. **Application Backup:**
   - Version control all configuration
   - Backup Docker images
   - Document deployment procedures

2. **Database Backup:**
   - Schedule regular backups
   - Test recovery procedures
   - Store backups off-site

3. **Disaster Recovery:**
   - Document recovery procedures
   - Maintain infrastructure as code
   - Test DR scenarios regularly

---

## Environment Variables

The application supports these environment variables:

- `SERVER_PORT`: Application port (default: 8080)
- `SPRING_PROFILES_ACTIVE`: Active profile (dev/staging/prod)
- `JAVA_OPTS`: JVM options
- `MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE`: Actuator endpoints

Example:
```bash
docker run -d \
  -e SERVER_PORT=8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e JAVA_OPTS="-Xms512m -Xmx1024m" \
  -p 8080:8080 \
  microservice:latest
```

---

## Troubleshooting

### Common Issues

1. **Port Already in Use:**
   ```bash
   # Find process using port 8080
   lsof -i :8080
   
   # Kill the process
   kill -9 <PID>
   ```

2. **Docker Build Fails:**
   ```bash
   # Clean Docker cache
   docker system prune -a
   
   # Rebuild without cache
   docker build --no-cache -t microservice:latest .
   ```

3. **Application Won't Start:**
   ```bash
   # Check logs
   docker logs microservice
   
   # Check WildFly logs
   docker exec microservice tail -f /opt/jboss/wildfly/standalone/log/server.log
   ```

4. **Out of Memory:**
   ```bash
   # Increase Docker memory limit
   docker run -m 2g microservice:latest
   
   # Adjust JVM heap
   docker run -e JAVA_OPTS="-Xmx1536m" microservice:latest
   ```

---

## Support

For issues or questions:
- Create an issue on GitHub
- Check the documentation
- Review logs for error messages
