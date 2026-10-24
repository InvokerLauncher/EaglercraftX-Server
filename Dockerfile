# Use a lightweight Linux container with Java 17 pre-packaged
FROM eclipse-temurin:17-jdk-jammy

# Safe Node.js 20 & dos2unix installation directly from official Ubuntu channels
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://nodesource.com | bash - && \
    apt-get install -y nodejs dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Establish the runtime directory structure
WORKDIR /app
COPY . .

# Convert layout spacing from Windows format (CRLF) to clean Linux format
RUN dos2unix bungee/*.sh server/*.sh main.sh 2>/dev/null || true
RUN chmod +x bungee/*.sh server/*.sh main.sh 2>/dev/null || true

# Pre-accept the Minecraft software configuration license
RUN echo "eula=true" > server/eula.txt

# Open the network proxy channels
EXPOSE 8081
EXPOSE 25565

# Launch both proxy environments simultaneously without tmux overhead
CMD java -Xmx512M -jar bungee/bungee.jar & java -Xmx1G -jar server/server.jar
