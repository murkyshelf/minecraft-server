#!/bin/bash

# Minecraft Fabric Server Docker Management Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to build the Docker image
build() {
    print_status "Building Minecraft server Docker image..."
    docker build -t minecraft-fabric-server .
    print_success "Docker image built successfully!"
}

# Function to start the server
start() {
    print_status "Starting Minecraft server..."
    docker-compose up -d
    print_success "Minecraft server started!"
    print_status "Server will be available on port 25565"
    print_status "Use 'docker-compose logs -f' to view logs"
}

# Function to stop the server
stop() {
    print_status "Stopping Minecraft server..."
    docker-compose down
    print_success "Minecraft server stopped!"
}

# Function to restart the server
restart() {
    print_status "Restarting Minecraft server..."
    docker-compose down
    docker-compose up -d
    print_success "Minecraft server restarted!"
}

# Function to show logs
logs() {
    print_status "Showing server logs..."
    docker-compose logs -f
}

# Function to enter the server console
console() {
    print_status "Connecting to server console..."
    print_warning "Use 'stop' command to safely shut down the server"
    docker-compose exec minecraft-server sh -c "echo 'help' > /proc/1/fd/0"
}

# Function to backup world data
backup() {
    BACKUP_DIR="./backups"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="minecraft_world_backup_${TIMESTAMP}.tar.gz"
    
    print_status "Creating backup..."
    mkdir -p "${BACKUP_DIR}"
    
    if [ -d "./world" ]; then
        tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" ./world
        print_success "Backup created: ${BACKUP_DIR}/${BACKUP_FILE}"
    else
        print_error "World directory not found!"
        exit 1
    fi
}

# Function to show server status
status() {
    print_status "Minecraft server status:"
    docker-compose ps
}

# Function to update the server
update() {
    print_status "Updating server (rebuilding image)..."
    docker-compose down
    docker build -t minecraft-fabric-server . --no-cache
    docker-compose up -d
    print_success "Server updated and restarted!"
}

# Function to show help
show_help() {
    echo "Minecraft Fabric Server Docker Management"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build    - Build the Docker image"
    echo "  start    - Start the server"
    echo "  stop     - Stop the server"
    echo "  restart  - Restart the server"
    echo "  logs     - Show server logs"
    echo "  console  - Access server console"
    echo "  backup   - Create world backup"
    echo "  status   - Show server status"
    echo "  update   - Update and rebuild server"
    echo "  help     - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start     # Start the server"
    echo "  $0 logs      # View server logs"
    echo "  $0 backup    # Create a world backup"
}

# Main script logic
check_docker

case "${1:-help}" in
    build)
        build
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    logs)
        logs
        ;;
    console)
        console
        ;;
    backup)
        backup
        ;;
    status)
        status
        ;;
    update)
        update
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac