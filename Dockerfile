# Use OpenJDK 21 as the base image (required for Minecraft 1.21.9)
FROM openjdk:21-jre-slim

# Set the working directory inside the container
WORKDIR /minecraft

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a minecraft user to run the server (security best practice)
RUN useradd -m -u 1000 minecraft && \
    chown -R minecraft:minecraft /minecraft

# Copy the server files
COPY --chown=minecraft:minecraft . /minecraft/

# Set proper permissions
RUN chmod +x /minecraft/*.jar

# Switch to minecraft user
USER minecraft

# Expose the default Minecraft port
EXPOSE 25565

# Set JVM options for optimal performance
ENV JAVA_OPTS="-Xmx4G -Xms2G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# Health check to ensure the server is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:25565 || exit 1

# Start the server
CMD java $JAVA_OPTS -jar fabric-server-mc.1.21.9-loader.0.17.2-launcher.1.1.0.jar nogui