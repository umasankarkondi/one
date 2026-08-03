# =========================
# Stage 1 - Build the WAR
# =========================
FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /app

# Copy Maven files
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests

# =========================
# Stage 2 - Tomcat
# =========================
FROM tomcat:9.0-jdk8-temurin

# Remove default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy Tomcat users
COPY tomcat-users.xml /usr/local/tomcat/conf/

# Copy WAR from builder
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]