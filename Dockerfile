































FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy only necessary files (avoid copying target/ and uploads/)
COPY pom.xml mvnw .mvn/ /app/
COPY src/ /app/src/

# Make mvnw executable and fix line endings
RUN apt-get update && apt-get install -y dos2unix && dos2unix mvnw && chmod +x mvnw

# Build the project and output logs for easier debugging
RUN ./mvnw clean package -DskipTests || (cat /app/target/*.log && exit 1)

# Expose the port your app runs on
EXPOSE 8080

# Run the jar
CMD ["java", "-jar", "target/cloudstore-backend-0.0.1-SNAPSHOT.jar"]
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy only necessary files (avoid copying target/ and uploads/)
COPY pom.xml mvnw .mvn/ /app/
COPY src/ /app/src/

# Make mvnw executable and fix line endings
RUN apt-get update && apt-get install -y dos2unix && dos2unix mvnw && chmod +x mvnw

# Build the project and output logs for easier debugging
RUN ./mvnw clean package -DskipTests || (cat /app/target/*.log && exit 1)

# Expose the port your app runs on
EXPOSE 8080

# Run the jar
CMD ["java", "-jar", "target/cloudstore-backend-0.0.1-SNAPSHOT.jar"]
