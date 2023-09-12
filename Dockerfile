FROM maven:3.8.4 AS build
WORKDIR /app

# Copy the Maven project files and build the application
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Create a lightweight image to run the application
FROM openjdk:11-jre-slim
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Remove all .jar files from the current directory
RUN rm -f *.jar

# Expose port 8080 for the Spring Boot application
EXPOSE 8080

# Entry point to run the Spring Boot application
CMD ["java", "-jar", "app.jar"]