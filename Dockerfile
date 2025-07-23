































FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy Maven wrapper and project files
COPY pom.xml mvnw /app/
COPY .mvn/ /app/.mvn/
COPY src/ /app/src/

# Make mvnw executable and fix line endings
RUN apt-get update && apt-get install -y dos2unix && dos2unix mvnw && chmod +x mvnw

# Set default JWT secret and expiration (can be overridden at runtime)
ENV JWT_SECRET=QwErTyUiOpAsDfGhJkLzXcVbNm1234567890QWERTYUIOPASDFGHJKLZXCVBNM
ENV JWT_EXPIRATION=604800000

# Build the project
RUN ./mvnw clean package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/cloudstore-backend-0.0.1-SNAPSHOT.jar"]
