# Installs a light Linux wrapper pre-packaged with Java 17
FROM eclipse-temurin:17-jdk-jammy

# Installs Node.js natively inside the container 
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://nodesource.com | bash - && \
    apt-get install -y nodejs dos2unix && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Fixes Windows layout bugs and ensures scripts are executable
RUN dos2unix bungee/*.sh server/*.sh main.sh 2>/dev/null || true
RUN chmod +x bungee/*.sh server/*.sh main.sh 2>/dev/null || true

# Accept the Minecraft EULA automatically
RUN echo "eula=true" > server/eula.txt

EXPOSE 8081
EXPOSE 25565

# Bypass main.sh and tmux completely by booting the jar files directly
CMD java -Xmx512M -jar bungee/bungee.jar & java -Xmx1G -jar server/server.jar
