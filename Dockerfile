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

# Force create the agreed EULA file inside the true server folder path
RUN mkdir -p server && echo "eula=true" > server/eula.txt

# Open the network proxy gates for connections
EXPOSE 10000
EXPOSE 25565

# Launch Bungee proxy and Paper server correctly inside their exact directories
CMD cd /app/bungee && java -Xmx512M -jar bungee.jar & cd /app/server && java -Xmx1G -jar server.jar
