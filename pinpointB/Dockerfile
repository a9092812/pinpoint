# Use a lightweight OpenJDK 17 base image
FROM eclipse-temurin:17-jdk-jammy

# Set working directory inside the container
WORKDIR /app

# Copy the built jar into the container
COPY target/pinpoint-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot app runs on
EXPOSE 8080


# Run the Spring Boot jar
ENTRYPOINT ["java","-jar","app.jar"]
