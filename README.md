# Minecraft Fabric Server Docker Setup

This directory contains a complete Docker setup for running your Minecraft Fabric server in a containerized environment.

## Files Overview

- `Dockerfile` - Docker image definition for the Minecraft server
- `docker-compose.yml` - Docker Compose configuration for easy management
- `manage-server.sh` - Management script for common operations
- `.dockerignore` - Files to exclude from Docker build context

## Quick Start

1. **Build and start the server:**
   ```bash
   ./manage-server.sh build
   ./manage-server.sh start
   ```

2. **View server logs:**
   ```bash
   ./manage-server.sh logs
   ```

3. **Stop the server:**
   ```bash
   ./manage-server.sh stop
   ```

## Management Commands

The `manage-server.sh` script provides the following commands:

- `build` - Build the Docker image
- `start` - Start the server
- `stop` - Stop the server
- `restart` - Restart the server
- `logs` - Show server logs
- `console` - Access server console
- `backup` - Create world backup
- `status` - Show server status
- `update` - Update and rebuild server

## Configuration

### Memory Settings

The server is configured with 4GB max memory and 2GB initial memory. You can adjust these in:
- `docker-compose.yml` (JAVA_OPTS environment variable)
- `Dockerfile` (ENV JAVA_OPTS)

### Port Configuration

- **25565** - Main Minecraft server port
- **25575** - RCON port (if enabled)

### Data Persistence

The following directories/files are persisted using Docker volumes:
- `world/` - Game world data
- `logs/` - Server logs
- `config/` - Mod configurations
- `banned-ips.json`, `banned-players.json`, `ops.json`, `whitelist.json`, `usercache.json`

## Advanced Usage

### Direct Docker Commands

If you prefer using Docker directly:

```bash
# Build the image
docker build -t minecraft-fabric-server .

# Run with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the server
docker-compose down
```

### Memory Tuning

For different server sizes, adjust the memory settings:

**Small server (2GB):**
```
JAVA_OPTS: "-Xmx2G -Xms1G ..."
```

**Large server (8GB):**
```
JAVA_OPTS: "-Xmx8G -Xms4G ..."
```

### Backup Strategy

Regular backups can be created using:
```bash
./manage-server.sh backup
```

Backups are stored in the `backups/` directory with timestamps.

## Troubleshooting

### Server Won't Start
1. Check if ports are available: `netstat -tuln | grep 25565`
2. Verify Docker is running: `docker info`
3. Check logs: `./manage-server.sh logs`

### Performance Issues
1. Increase memory allocation in `docker-compose.yml`
2. Adjust JVM flags for your hardware
3. Monitor resource usage: `docker stats`

### Connection Issues
1. Ensure port 25565 is open in your firewall
2. Verify the server is bound to correct IP in `server.properties`
3. Check if Docker container is running: `./manage-server.sh status`

## Security Considerations

- The server runs as non-root user inside the container
- Only necessary ports are exposed
- Resource limits are configured to prevent resource exhaustion
- Sensitive data is persisted outside the container

## Server Properties

Your current server configuration:
- **Port:** 25565
- **Max Players:** 10
- **Game Mode:** Survival
- **Difficulty:** Easy
- **Online Mode:** Disabled
- **EULA:** Accepted

To modify these settings, edit `server.properties` and restart the server.