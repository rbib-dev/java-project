# API Documentation

## Base URL

When running locally with embedded Tomcat:
```
http://localhost:8080/microservice
```

When running in Docker with WildFly:
```
http://localhost:8080/microservice
```

## Endpoints

### 1. Hello World

Returns a simple hello message.

**Endpoint:** `GET /api/hello`

**Response:**
```json
{
  "message": "Hello from Spring Boot Microservice!",
  "status": "success"
}
```

**cURL Example:**
```bash
curl http://localhost:8080/microservice/api/hello
```

---

### 2. Personalized Hello

Returns a personalized hello message.

**Endpoint:** `GET /api/hello/{name}`

**Path Parameters:**
- `name` (string, required): The name to greet

**Response:**
```json
{
  "message": "Hello, John!",
  "status": "success"
}
```

**cURL Example:**
```bash
curl http://localhost:8080/microservice/api/hello/John
```

---

### 3. Health Check

Returns the health status of the service.

**Endpoint:** `GET /api/health`

**Response:**
```json
{
  "status": "UP",
  "service": "microservice"
}
```

**cURL Example:**
```bash
curl http://localhost:8080/microservice/api/health
```

---

## Spring Boot Actuator Endpoints

### Health

Detailed health information from Spring Boot Actuator.

**Endpoint:** `GET /actuator/health`

**Response:**
```json
{
  "status": "UP"
}
```

**cURL Example:**
```bash
curl http://localhost:8080/microservice/actuator/health
```

---

### Info

Application information.

**Endpoint:** `GET /actuator/info`

**cURL Example:**
```bash
curl http://localhost:8080/microservice/actuator/info
```

---

### Metrics

Application metrics.

**Endpoint:** `GET /actuator/metrics`

**cURL Example:**
```bash
curl http://localhost:8080/microservice/actuator/metrics
```

To view a specific metric:
```bash
curl http://localhost:8080/microservice/actuator/metrics/jvm.memory.used
```

---

## Testing the API

### Using cURL

```bash
# Test hello endpoint
curl -X GET http://localhost:8080/microservice/api/hello

# Test personalized hello
curl -X GET http://localhost:8080/microservice/api/hello/DevOps

# Test health check
curl -X GET http://localhost:8080/microservice/api/health

# Test actuator health
curl -X GET http://localhost:8080/microservice/actuator/health
```

### Using HTTPie

```bash
# Test hello endpoint
http GET http://localhost:8080/microservice/api/hello

# Test personalized hello
http GET http://localhost:8080/microservice/api/hello/DevOps

# Test health check
http GET http://localhost:8080/microservice/api/health
```

### Using Postman

1. Import the base URL: `http://localhost:8080/microservice`
2. Create GET requests for each endpoint
3. Test and save responses

---

## Response Formats

All endpoints return JSON responses with appropriate HTTP status codes:

- `200 OK`: Successful request
- `404 Not Found`: Endpoint not found
- `500 Internal Server Error`: Server error

---

## CORS

By default, the application accepts requests from any origin. For production, configure CORS appropriately in the Spring Boot configuration.

---

## Rate Limiting

Currently, there is no rate limiting implemented. Consider adding rate limiting for production deployments.
