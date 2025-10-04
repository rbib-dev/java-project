# Java Microservice Project

A Spring Boot microservice running on WildFly application server with Docker and Jenkins CI/CD support.

## Overview

This project demonstrates a complete microservice setup with:
- **Spring Boot**: Framework for building the microservice
- **WildFly**: Application server for deployment
- **Docker**: Containerization support
- **Jenkins**: CI/CD pipeline automation
- **Maven**: Build and dependency management

## Prerequisites

- Java 11 or higher
- Maven 3.6+
- Docker and Docker Compose
- Jenkins (optional, for CI/CD)

## Project Structure

```
java-project/
├── src/
│   ├── main/
│   │   ├── java/com/example/microservice/
│   │   │   ├── Application.java              # Main Spring Boot application
│   │   │   └── controller/
│   │   │       └── HelloController.java      # REST API controller
│   │   └── resources/
│   │       └── application.properties        # Application configuration
│   └── test/
│       └── java/com/example/microservice/
│           └── ApplicationTest.java          # Unit tests
├── pom.xml                                   # Maven configuration
├── Dockerfile                                # Docker image definition
├── docker-compose.yml                        # Docker Compose configuration
├── Jenkinsfile                               # Jenkins pipeline definition
└── README.md                                 # This file
```

## Building the Application

### Using Maven

```bash
# Compile the code
mvn clean compile

# Run tests
mvn test

# Package the application
mvn package

# The WAR file will be created at: target/microservice.war
```

### Using Docker

```bash
# Build the Docker image
docker build -t microservice:latest .

# Run the container
docker run -p 8080:8080 -p 9990:9990 microservice:latest
```

### Using Docker Compose

```bash
# Start the service
docker-compose up -d

# Stop the service
docker-compose down

# View logs
docker-compose logs -f
```

## Running the Application

### Standalone (embedded Tomcat)

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080/microservice`

### On WildFly (via Docker)

```bash
docker-compose up
```

The application will be deployed to WildFly and accessible at:
- Application: `http://localhost:8080/microservice`
- WildFly Admin Console: `http://localhost:9990`

## API Endpoints

The microservice exposes the following REST API endpoints:

### Hello World
```bash
GET http://localhost:8080/microservice/api/hello
```

Response:
```json
{
  "message": "Hello from Spring Boot Microservice!",
  "status": "success"
}
```

### Personalized Hello
```bash
GET http://localhost:8080/microservice/api/hello/{name}
```

Example:
```bash
curl http://localhost:8080/microservice/api/hello/John
```

Response:
```json
{
  "message": "Hello, John!",
  "status": "success"
}
```

### Health Check
```bash
GET http://localhost:8080/microservice/api/health
```

Response:
```json
{
  "status": "UP",
  "service": "microservice"
}
```

### Actuator Endpoints

Spring Boot Actuator provides additional monitoring endpoints:

- Health: `http://localhost:8080/microservice/actuator/health`
- Info: `http://localhost:8080/microservice/actuator/info`
- Metrics: `http://localhost:8080/microservice/actuator/metrics`

## Jenkins CI/CD Pipeline

The `Jenkinsfile` defines a complete CI/CD pipeline with the following stages:

1. **Checkout**: Pulls the source code from the repository
2. **Build**: Compiles the Java code
3. **Test**: Runs unit tests
4. **Package**: Creates the WAR file
5. **Code Analysis**: Runs static code analysis
6. **Build Docker Image**: Creates a Docker image
7. **Push Docker Image**: Pushes to Docker registry (main branch only)
8. **Deploy**: Deploys the application (main branch only)

### Setting up Jenkins

1. Install required plugins:
   - Pipeline
   - Docker Pipeline
   - Maven Integration
   - JUnit

2. Configure tools in Jenkins:
   - Maven 3.8.6
   - JDK 11

3. Create a new Pipeline job and point it to this repository

4. Configure credentials for Docker registry (if using push stage)

## Configuration

### Application Properties

Key configurations in `src/main/resources/application.properties`:

- `server.port`: Application port (default: 8080)
- `server.servlet.context-path`: Context path (default: /microservice)
- `management.endpoints.web.exposure.include`: Actuator endpoints to expose

### Docker Configuration

The `Dockerfile` uses a multi-stage build:
1. **Build stage**: Compiles and packages the application using Maven
2. **Runtime stage**: Deploys to WildFly application server

### WildFly Ports

- `8080`: HTTP port for the application
- `9990`: Management console port

## Development

### Adding New Endpoints

1. Create a new controller in `src/main/java/com/example/microservice/controller/`
2. Annotate with `@RestController`
3. Define your endpoints using `@GetMapping`, `@PostMapping`, etc.

### Running Tests

```bash
mvn test
```

### Live Reload

The project includes Spring Boot DevTools for automatic restart during development:

```bash
mvn spring-boot:run
```

## Deployment

### Local Deployment

```bash
# Build and deploy with Docker Compose
docker-compose up -d
```

### Production Deployment

1. Build the Docker image
2. Push to your Docker registry
3. Pull and run on your production server
4. Or use the Jenkins pipeline for automated deployment

## Monitoring and Health Checks

The application includes:
- Custom health endpoint at `/api/health`
- Spring Boot Actuator health endpoint at `/actuator/health`
- Docker health check configured in docker-compose.yml

## Troubleshooting

### Port Already in Use

If port 8080 is already in use:
- Change the port in `application.properties`
- Or map to a different port in Docker: `-p 8081:8080`

### Build Failures

```bash
# Clean and rebuild
mvn clean install

# Skip tests if needed
mvn clean package -DskipTests
```

### Docker Issues

```bash
# Remove old containers and images
docker-compose down
docker system prune -a

# Rebuild from scratch
docker-compose build --no-cache
docker-compose up
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is open source and available under the MIT License.

## Contact

For questions or support, please open an issue in the GitHub repository.
