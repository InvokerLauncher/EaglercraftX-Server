# Use a lightweight Linux container with Java 17 pre-installed
FROM eclipse-temurin:17-jdk-jammy

# Install Node.js and dos2unix directly from safe system package managers
RUN apt-get update && \
    apt-get install -y nodejs npm dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Establish our app folder structure
WORKDIR /app
COPY . .

# Clean out hidden Windows line spacing symbols from scripts
RUN dos2unix bungee/*.sh server/*.sh main.sh 2>/dev/null || true
RUN chmod +x bungee/*.sh server/*.sh main.sh 2>/dev/null || true

# Pre-accept the Minecraft software license
RUN echo "eula=true" > server/eula.txt

# Open the network proxy gates for connections
EXPOSE 8081
EXPOSE 25565

# Launch both proxy environments side-by-side automatically
CMD java -Xmx512M -jar bungee/bungee.jar & java -Xmx1G -jar server/server.jar
