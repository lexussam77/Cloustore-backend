































FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy Maven wrapper and project files
COPY pom.xml mvnw /app/
COPY .mvn/ /app/.mvn/
COPY src/ /app/src/

# Make mvnw executable and fix line endings
RUN apt-get update && apt-get install -y dos2unix && dos2unix mvnw && chmod +x mvnw

ENV JWT_SECRET=QwErTyUiOpAsDfGhJkLzXcVbNm1234567890QWERTYUIOPASDFGHJKLZXCVBNM
ENV JWT_EXPIRATION=604800000

# Set default database environment variables (can be overridden at runtime)
ENV JDBC_DATABASE_URL=jdbc:postgresql://ep-restless-paper-ab7uwvsx-pooler.eu-west-2.aws.neon.tech:5432/CloudStore?sslmode=require&channel_binding=require
ENV JDBC_DATABASE_USERNAME=neondb_owner
ENV JDBC_DATABASE_PASSWORD=npg_3nHdEiYfm6qU
ENV JDBC_DATABASE_DRIVER=org.postgresql.Driver

# Build the project
RUN ./mvnw clean package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/cloudstore-backend-0.0.1-SNAPSHOT.jar"]
