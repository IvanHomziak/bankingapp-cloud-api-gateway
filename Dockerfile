# Base image
FROM openjdk:18-jdk-alpine

# Install required dependencies
RUN apk --no-cache add git curl maven

# Set working directory
WORKDIR /app

# Clone and build bankingapp-common
RUN git clone https://github.com/IvanHomziak/bankingapp-common.git && \
    cd bankingapp-common && \
    mvn clean install -DskipTests

# Go back to /app directory
WORKDIR /app

# Copy project files (excluding `src` to use caching efficiently)
COPY pom.xml .

# Resolve dependencies (this speeds up builds by using caching)
RUN mvn dependency:resolve

# Copy the rest of the source code
COPY src src

# Build the project
RUN mvn clean package -DskipTests

# Run the application
ENTRYPOINT ["java", "-jar", "target/bankingapp-cloud-api-gateway-ms.jar"]