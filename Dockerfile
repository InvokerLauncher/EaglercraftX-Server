# Establish a robust base image containing Java 17
FROM eclipse-temurin:17-jdk-jammy

# Safely install Node.js 20 and dos2unix formatting utilities without sudo
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://nodesource.com | bash - && \
    apt-get install -y nodejs dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /app

# Copy all repository code into the container
COPY . .

# Sanitize file endings from Windows layout to Linux execution architecture
RUN dos2unix main.sh bungee/*.sh server/*.sh 2>/dev/null || true
RUN chmod +x main.sh bungee/*.sh server/*.sh 2>/dev/null || true

# Expose proxy ports to handle the web connections
EXPOSE 8081
EXPOSE 25565

# Execute the application through your central orchestration script
CMD ["bash", "main.sh"]
