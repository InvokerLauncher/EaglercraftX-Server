# Use a Linux environment with Java pre-installed
FROM eclipse-temurin:17-jdk-jammy

# Install Node.js and dos2unix to fix file formatting
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://nodesource.com | bash - && \
    apt-get install -y nodejs dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /app

# Copy all repository files into the container
COPY . .

# Fix the broken Windows line endings (CRLF) for all scripts
RUN dos2unix main.sh bungee/*.sh server/*.sh 2>/dev/null || true
RUN chmod +x main.sh bungee/*.sh server/*.sh 2>/dev/null || true

# Expose Bungee's web port 
EXPOSE 8081
EXPOSE 25565

# Start your network using your main script
CMD ["bash", "main.sh"]
