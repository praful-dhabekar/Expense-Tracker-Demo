# ---------- Build Stage ----------
FROM maven:3.9.11-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first for dependency caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source
COPY src ./src

# Build
RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy jar from build stage
COPY --from=builder /app/target/*.jar app.jar

# Cloud Run uses PORT env variable
ENV PORT=8080

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
