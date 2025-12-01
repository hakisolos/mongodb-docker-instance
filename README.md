# mongodb-docker-instance# Complete MongoDB Docker Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Repository Setup](#repository-setup)
4. [Dockerfile Explanation](#dockerfile-explanation)
5. [docker-compose.yml Explanation](#docker-composeyml-explanation)
6. [Build and Run](#build-and-run)
7. [Connecting to MongoDB](#connecting-to-mongodb)
8. [Data Persistence](#data-persistence)
9. [Troubleshooting](#troubleshooting)
10. [Optional Enhancements](#optional-enhancements)

---

## Introduction

### What This Project Does
This project provides a ready-to-use MongoDB database server running inside a Docker container. It creates an isolated MongoDB instance that you can use for development, testing, or learning purposes without installing MongoDB directly on your computer.

### Why Use This?
- **Isolation**: Keep your MongoDB instance separate from your main system
- **Portability**: Run the same MongoDB setup on any computer with Docker
- **Easy Cleanup**: Delete the container when done without leaving traces on your system
- **Version Control**: Lock your MongoDB version (6.0) for consistency
- **Quick Setup**: Get MongoDB running in minutes instead of dealing with complex installations

---

## Prerequisites

Before starting, you need to install Docker (and optionally Git) on your system.

### Docker Installation

#### Windows
1. Download Docker Desktop for Windows from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Run the installer and follow the setup wizard
3. Restart your computer when prompted
4. Open Docker Desktop and wait for it to start
5. Verify installation by opening Command Prompt or PowerShell and typing:
   ```bash
   docker --version
   ```
   You should see output like: `Docker version 24.0.x, build xxxxx`

#### Mac
1. Download Docker Desktop for Mac from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Open the downloaded `.dmg` file
3. Drag Docker to your Applications folder
4. Open Docker from Applications and follow the setup prompts
5. Verify installation by opening Terminal and typing:
   ```bash
   docker --version
   ```

#### Linux (Ubuntu/Debian)
1. Update your package index:
   ```bash
   sudo apt-get update
   ```
2. Install required packages:
   ```bash
   sudo apt-get install ca-certificates curl gnupg lsb-release
   ```
3. Add Docker's official GPG key:
   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```
4. Set up the repository:
   ```bash
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```
5. Install Docker Engine:
   ```bash
   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
   ```
6. Verify installation:
   ```bash
   docker --version
   ```

### Git Installation (Optional)
If you plan to clone a repository, you'll need Git:

- **Windows**: Download from [https://git-scm.com/download/win](https://git-scm.com/download/win)
- **Mac**: Install via Homebrew: `brew install git` or download from [https://git-scm.com/download/mac](https://git-scm.com/download/mac)
- **Linux**: `sudo apt-get install git` (Ubuntu/Debian) or `sudo yum install git` (CentOS/Fedora)

---

## Repository Setup

### Option 1: Clone from Git (if the project is hosted online)
1. Open your terminal (Command Prompt, PowerShell, or Terminal)
2. Navigate to where you want the project:
   ```bash
   cd /path/to/your/projects
   ```
3. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
4. Navigate into the project folder:
   ```bash
   cd <project-folder-name>
   ```

### Option 2: Create Manually
1. Create a new folder for your project:
   ```bash
   mkdir mongodb-docker-project
   cd mongodb-docker-project
   ```
2. Create a file named `Dockerfile` (no extension) with the following content:
   ```dockerfile
   FROM mongo:6.0
   ENV MONGO_USERNAME=admin
   ENV MONGO_PASSWORD=admin
   ENV MONGO_DATABASE_NAME=haki1234
   EXPOSE 27017
   ```
3. Create a file named `docker-compose.yml` with the following content:
   ```yaml
   version: "3.8"
   services:
     mongo:
       build: .
       container_name: my_mongo
       ports:
         - "27017:27017"
       environment:
         MONGO_USERNAME: admin
         MONGO_PASSWORD: admin
         MONGO_DATABASE_NAME: haki1234
   ```

---

## Dockerfile Explanation

Let's break down each line of the Dockerfile:

```dockerfile
FROM mongo:6.0
```
- **What it does**: This tells Docker to start with the official MongoDB 6.0 image as the base
- **Why it matters**: Instead of building MongoDB from scratch, we use a pre-configured, tested image maintained by MongoDB's team
- **The version**: `6.0` ensures you always get MongoDB version 6.0, providing consistency

```dockerfile
ENV MONGO_USERNAME=admin
```
- **What it does**: Creates an environment variable named `MONGO_USERNAME` with value `admin`
- **Purpose**: This will be used later to configure MongoDB authentication
- **Customization**: Change `admin` to any username you prefer

```dockerfile
ENV MONGO_PASSWORD=admin
```
- **What it does**: Creates an environment variable for the MongoDB password
- **Purpose**: Stores the password that will be used for authentication
- **Security Note**: Change `admin` to a strong password for production use
- **Customization**: Replace `admin` with your desired password

```dockerfile
ENV MONGO_DATABASE_NAME=haki1234
```
- **What it does**: Sets the name of the default database
- **Purpose**: Specifies which database will be created and used
- **Customization**: Change `haki1234` to your preferred database name (use letters, numbers, and underscores only)

```dockerfile
EXPOSE 27017
```
- **What it does**: Documents that the container will listen on port 27017
- **Why 27017**: This is MongoDB's default port
- **Note**: This is informational - the actual port mapping is done in docker-compose.yml

### How to Customize
To change the username, password, or database name:
1. Open the `Dockerfile` in any text editor
2. Modify the values after the `=` sign:
   ```dockerfile
   ENV MONGO_USERNAME=myuser
   ENV MONGO_PASSWORD=MySecurePassword123!
   ENV MONGO_DATABASE_NAME=myapp_database
   ```
3. Save the file
4. Rebuild the Docker image (see Build and Run section)

---

## docker-compose.yml Explanation

Docker Compose is a tool for defining and running multi-container applications. Even though we only have one container here, it simplifies the process.

```yaml
version: "3.8"
```
- **What it does**: Specifies the Docker Compose file format version
- **Why 3.8**: This version is widely supported and includes all features we need

```yaml
services:
```
- **What it does**: Begins the definition of services (containers) in this project
- **Services**: Think of each service as a separate container

```yaml
  mongo:
```
- **What it does**: Names our service "mongo"
- **Purpose**: You'll reference this name when managing the container

```yaml
    build: .
```
- **What it does**: Tells Docker Compose to build an image using the Dockerfile in the current directory (`.`)
- **Alternative**: You could use `image: mongo:6.0` to use the official image directly without customization

```yaml
    container_name: my_mongo
```
- **What it does**: Assigns a specific name to the running container
- **Why it matters**: Makes it easier to identify and manage the container
- **Customization**: Change `my_mongo` to any name you prefer

```yaml
    ports:
      - "27017:27017"
```
- **What it does**: Maps ports between your computer and the container
- **Format**: `"HOST_PORT:CONTAINER_PORT"`
- **Meaning**: Port 27017 on your computer connects to port 27017 in the container
- **Customization**: To use a different port on your computer (if 27017 is taken), change the first number:
  ```yaml
  - "27018:27017"
  ```
  Then connect using port 27018

```yaml
    environment:
      MONGO_USERNAME: admin
      MONGO_PASSWORD: admin
      MONGO_DATABASE_NAME: haki1234
```
- **What it does**: Sets environment variables inside the container
- **Note**: These override the ENV values in the Dockerfile
- **Customization**: Change these values to customize your setup:
  ```yaml
  environment:
    MONGO_USERNAME: myuser
    MONGO_PASSWORD: MySecurePassword123!
    MONGO_DATABASE_NAME: production_db
  ```

### Complete Customization Example
Here's how your `docker-compose.yml` might look after customization:

```yaml
version: "3.8"
services:
  mongo:
    build: .
    container_name: my_custom_mongodb
    ports:
      - "27018:27017"
    environment:
      MONGO_USERNAME: johndoe
      MONGO_PASSWORD: SecurePass456!
      MONGO_DATABASE_NAME: my_application_db
```

---

## Build and Run

There are two main ways to build and run your MongoDB container: using Docker commands directly or using Docker Compose.

### Method 1: Using Docker Commands

#### Step 1: Build the Docker Image
```bash
docker build -t my-mongodb-image .
```
- `docker build`: Command to build an image
- `-t my-mongodb-image`: Tags (names) the image "my-mongodb-image"
- `.`: Uses the Dockerfile in the current directory

**Expected output**: You'll see Docker downloading layers and building the image. This may take a few minutes the first time.

#### Step 2: Run the Container
```bash
docker run -d -p 27017:27017 --name my_mongo my-mongodb-image
```
- `docker run`: Command to create and start a container
- `-d`: Runs in detached mode (background)
- `-p 27017:27017`: Maps port 27017
- `--name my_mongo`: Names the container "my_mongo"
- `my-mongodb-image`: The image to use

#### Step 3: Verify It's Running
```bash
docker ps
```
You should see your container listed with status "Up".

### Method 2: Using Docker Compose (Recommended)

#### Step 1: Build and Start
```bash
docker-compose up -d
```
- `docker-compose up`: Builds (if needed) and starts containers
- `-d`: Runs in detached mode (background)

**What happens**:
1. Docker Compose reads `docker-compose.yml`
2. Builds the image using the Dockerfile
3. Creates and starts the container
4. Maps the ports as specified

**Expected output**:
```
Creating network "mongodb-docker-project_default" with the default driver
Building mongo
...
Creating my_mongo ... done
```

#### Step 2: Verify It's Running
```bash
docker-compose ps
```
You should see:
```
   Name                 Command             State           Ports
------------------------------------------------------------------------
my_mongo   docker-entrypoint.sh mongod   Up      0.0.0.0:27017->27017/tcp
```

### Useful Commands

#### Stop the Container
**Docker**:
```bash
docker stop my_mongo
```

**Docker Compose**:
```bash
docker-compose stop
```

#### Start a Stopped Container
**Docker**:
```bash
docker start my_mongo
```

**Docker Compose**:
```bash
docker-compose start
```

#### Stop and Remove the Container
**Docker**:
```bash
docker stop my_mongo
docker rm my_mongo
```

**Docker Compose**:
```bash
docker-compose down
```

#### View Container Logs
**Docker**:
```bash
docker logs my_mongo
```

**Docker Compose**:
```bash
docker-compose logs mongo
```

Add `-f` to follow logs in real-time:
```bash
docker logs -f my_mongo
```

#### Restart the Container
**Docker**:
```bash
docker restart my_mongo
```

**Docker Compose**:
```bash
docker-compose restart
```

---

## Connecting to MongoDB

Once your container is running, you can connect to MongoDB using various tools.

### Connection String Format
```
mongodb://username:password@host:port/database
```

**For this project**:
```
mongodb://admin:admin@localhost:27017/haki1234
```

**Replace with your values**:
- `admin:admin` → your username and password
- `localhost` → stays the same (unless accessing from another machine)
- `27017` → the host port (first number in ports mapping)
- `haki1234` → your database name

### Method 1: MongoDB Compass (GUI Tool)

MongoDB Compass is a free graphical interface for MongoDB.

#### Step 1: Install MongoDB Compass
Download from [https://www.mongodb.com/try/download/compass](https://www.mongodb.com/try/download/compass)

#### Step 2: Open Compass
Launch the application

#### Step 3: Create New Connection
1. Click "New Connection"
2. You'll see a connection string field

#### Step 4: Enter Connection String
Paste your connection string:
```
mongodb://admin:admin@localhost:27017/haki1234
```

Or use the Advanced Connection Options:
- **Hostname**: `localhost`
- **Port**: `27017`
- **Authentication**: Username/Password
  - **Username**: `admin`
  - **Password**: `admin`
- **Authentication Database**: `admin`

#### Step 5: Connect
Click "Connect" and you should see your database

### Method 2: MongoDB Shell (Command Line)

#### Step 1: Access the Container's Shell
```bash
docker exec -it my_mongo mongosh
```
- `docker exec`: Execute a command in a running container
- `-it`: Interactive terminal
- `my_mongo`: Container name
- `mongosh`: MongoDB shell command

#### Step 2: Switch to Your Database
```javascript
use haki1234
```

#### Step 3: Run MongoDB Commands
```javascript
// Insert a document
db.users.insertOne({ name: "John Doe", email: "john@example.com" })

// Find documents
db.users.find()

// Count documents
db.users.countDocuments()
```

#### Step 4: Exit the Shell
```javascript
exit
```

### Method 3: From Your Application

#### Node.js Example
```javascript
const { MongoClient } = require('mongodb');

const uri = "mongodb://admin:admin@localhost:27017/haki1234";
const client = new MongoClient(uri);

async function run() {
  try {
    await client.connect();
    console.log("Connected to MongoDB!");
    
    const database = client.db("haki1234");
    const users = database.collection("users");
    
    // Insert a document
    const result = await users.insertOne({ name: "Jane Doe" });
    console.log(`Inserted document with id: ${result.insertedId}`);
    
  } finally {
    await client.close();
  }
}

run().catch(console.dir);
```

#### Python Example
```python
from pymongo import MongoClient

uri = "mongodb://admin:admin@localhost:27017/haki1234"
client = MongoClient(uri)

db = client["haki1234"]
collection = db["users"]

# Insert a document
result = collection.insert_one({"name": "Jane Doe"})
print(f"Inserted document with id: {result.inserted_id}")

# Find documents
for doc in collection.find():
    print(doc)

client.close()
```

### Troubleshooting Connection Issues

If you can't connect:

1. **Verify the container is running**:
   ```bash
   docker ps
   ```
   
2. **Check the logs for errors**:
   ```bash
   docker logs my_mongo
   ```

3. **Ensure the port is correct**:
   - Check your `docker-compose.yml` ports mapping
   - Use the first number (host port) in your connection string

4. **Test from inside the container**:
   ```bash
   docker exec -it my_mongo mongosh
   ```
   If this works, the issue is with external connectivity

---

## Data Persistence

### Understanding Container Data

**Important**: By default, data inside a Docker container is temporary. If you remove the container, all data is lost.

**Example scenario**:
1. You create a database and add documents
2. You run `docker-compose down`
3. All your data is gone forever

### Solution: Volume Mounting

To persist data, you need to mount a folder from your computer to the container's data directory.

#### Step 1: Update docker-compose.yml

Add a `volumes` section:

```yaml
version: "3.8"
services:
  mongo:
    build: .
    container_name: my_mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_USERNAME: admin
      MONGO_PASSWORD: admin
      MONGO_DATABASE_NAME: haki1234
    volumes:
      - ./mongodb-data:/data/db
```

**What this does**:
- `./mongodb-data`: A folder on your computer (will be created automatically)
- `:/data/db`: MongoDB's data directory inside the container
- Data written to `/data/db` in the container is actually stored in `./mongodb-data` on your computer

#### Step 2: Restart with Volumes

If the container is running, stop and remove it:
```bash
docker-compose down
```

Start it again with the new configuration:
```bash
docker-compose up -d
```

#### Step 3: Verify Data Persistence

1. Connect to MongoDB and create some data
2. Stop the container: `docker-compose down`
3. Start it again: `docker-compose up -d`
4. Connect again - your data should still be there

### Using Docker Named Volumes (Alternative)

Instead of a local folder, you can use Docker-managed volumes:

```yaml
version: "3.8"
services:
  mongo:
    build: .
    container_name: my_mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_USERNAME: admin
      MONGO_PASSWORD: admin
      MONGO_DATABASE_NAME: haki1234
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
```

**Advantages**:
- Docker manages the storage location
- Better performance on Windows and Mac
- Easier to back up with Docker commands

**Managing named volumes**:
```bash
# List volumes
docker volume ls

# Inspect a volume
docker volume inspect mongodb_data

# Remove a volume (when container is stopped)
docker volume rm mongodb_data
```

### Backing Up Your Data

#### Using Docker Compose with Local Folder
Simply copy the `mongodb-data` folder:
```bash
# Linux/Mac
cp -r ./mongodb-data ./mongodb-data-backup

# Windows
xcopy mongodb-data mongodb-data-backup /E /I
```

#### Using mongodump
```bash
# Create a backup
docker exec my_mongo mongodump --out=/backup

# Copy backup to your computer
docker cp my_mongo:/backup ./backup
```

#### Restoring from Backup
```bash
# Copy backup to container
docker cp ./backup my_mongo:/backup

# Restore
docker exec my_mongo mongorestore /backup
```

---

## Troubleshooting

### Issue 1: Port Already in Use

**Error message**:
```
Error starting userland proxy: listen tcp4 0.0.0.0:27017: bind: address already in use
```

**Cause**: Another program is using port 27017 (maybe another MongoDB instance)

**Solutions**:

**Option A**: Stop the other program using port 27017
```bash
# Find what's using the port (Linux/Mac)
lsof -i :27017

# Find what's using the port (Windows)
netstat -ano | findstr :27017

# Stop MongoDB if it's running locally
# Linux/Mac
sudo systemctl stop mongod

# Windows
net stop MongoDB
```

**Option B**: Use a different port
In `docker-compose.yml`, change the first port number:
```yaml
ports:
  - "27018:27017"
```
Then use port 27018 in your connection string

### Issue 2: Docker Daemon Not Running

**Error message**:
```
Cannot connect to the Docker daemon. Is the docker daemon running?
```

**Solution**:
- **Windows/Mac**: Open Docker Desktop and wait for it to start
- **Linux**: Start Docker service
  ```bash
  sudo systemctl start docker
  ```

### Issue 3: Connection Refused

**Error message**:
```
MongoNetworkError: connect ECONNREFUSED 127.0.0.1:27017
```

**Causes and Solutions**:

1. **Container not running**
   ```bash
   # Check if running
   docker ps
   
   # If not listed, start it
   docker-compose up -d
   ```

2. **Wrong port in connection string**
   - Check your `docker-compose.yml` ports mapping
   - Use the first number (host port)

3. **Firewall blocking connection**
   - Temporarily disable firewall to test
   - Add exception for port 27017

### Issue 4: Authentication Failed

**Error message**:
```
MongoServerError: Authentication failed
```

**Causes and Solutions**:

1. **Wrong credentials in connection string**
   - Verify username and password match your `docker-compose.yml`
   - Check for typos

2. **MongoDB authentication not enabled**
   - The basic setup doesn't enable authentication by default
   - See Optional Enhancements section for proper authentication

3. **Wrong authentication database**
   - Try specifying `?authSource=admin` in connection string:
   ```
   mongodb://admin:admin@localhost:27017/haki1234?authSource=admin
   ```

### Issue 5: Container Keeps Restarting

**Check logs**:
```bash
docker logs my_mongo
```

**Common causes**:

1. **Permission issues with volume**
   ```bash
   # Fix permissions (Linux/Mac)
   sudo chown -R 999:999 ./mongodb-data
   ```

2. **Corrupted data directory**
   - Stop container
   - Delete `mongodb-data` folder
   - Start container again (will create fresh database)

### Issue 6: Out of Disk Space

**Error in logs**:
```
No space left on device
```

**Solutions**:

1. **Clean up Docker**
   ```bash
   # Remove unused images, containers, and volumes
   docker system prune -a
   
   # Remove unused volumes specifically
   docker volume prune
   ```

2. **Free up disk space on your computer**

### Issue 7: Can't Access from Another Computer

**Problem**: You want to connect from a different machine on your network

**Solution**:
1. Change connection string from `localhost` to your computer's IP address:
   ```
   mongodb://admin:admin@192.168.1.100:27017/haki1234
   ```

2. Ensure firewall allows connections on port 27017

3. Make sure Docker is binding to all interfaces (it should by default with the current config)

### Getting More Help

If you're still stuck:

1. **Check detailed logs**:
   ```bash
   docker logs -f my_mongo
   ```

2. **Inspect the container**:
   ```bash
   docker inspect my_mongo
   ```

3. **Try accessing from inside the container**:
   ```bash
   docker exec -it my_mongo mongosh
   ```
   If this works, the issue is with external connectivity

---

## Optional Enhancements

### Enhancement 1: Proper MongoDB Authentication

The current setup doesn't actually enable MongoDB authentication. Here's how to do it properly:

#### Step 1: Update docker-compose.yml
```yaml
version: "3.8"
services:
  mongo:
    image: mongo:6.0
    container_name: my_mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: securepassword123
      MONGO_INITDB_DATABASE: haki1234
    volumes:
      - ./mongodb-data:/data/db
```

**Key changes**:
- Use official `mongo:6.0` image directly
- Use MongoDB's official environment variables:
  - `MONGO_INITDB_ROOT_USERNAME`: Creates root user
  - `MONGO_INITDB_ROOT_PASSWORD`: Sets root password
  - `MONGO_INITDB_DATABASE`: Creates initial database

#### Step 2: Connect with Authentication
```
mongodb://admin:securepassword123@localhost:27017/haki1234?authSource=admin
```

Note the `?authSource=admin` - this tells MongoDB to authenticate against the admin database.

### Enhancement 2: Using a .env File

Instead of hardcoding credentials, use environment variables:

#### Step 1: Create .env File
Create a file named `.env` in the same directory:
```
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=securepassword123
MONGO_DATABASE=haki1234
MONGO_PORT=27017
```

#### Step 2: Update docker-compose.yml
```yaml
version: "3.8"
services:
  mongo:
    image: mongo:6.0
    container_name: my_mongo
    ports:
      - "${MONGO_PORT}:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
      MONGO_INITDB_DATABASE: ${MONGO_DATABASE}
    volumes:
      - ./mongodb-data:/data/db
```

#### Step 3: Add .env to .gitignore
Create a `.gitignore` file:
```
.env
mongodb-data/
```

This prevents sensitive credentials from being committed to Git.

#### Step 4: Create .env.example
Create a template for other developers:
```
MONGO_ROOT_USERNAME=your_username
MONGO_ROOT_PASSWORD=your_password
MONGO_DATABASE=your_database
MONGO_PORT=27017
```

### Enhancement 3: Running on Render

Render is a cloud platform where you can deploy Docker containers.

#### Step 1: Prepare Your Repository
1. Push your Dockerfile and docker-compose.yml to GitHub
2. Include the .env.example but not .env
3. Add a README with setup instructions

#### Step 2: Sign Up for Render
Go to [https://render.com](https://render.com) and create an account

#### Step 3: Create a New Service
1. Click "New +" and select "Background Worker" or "Web Service"
2. Connect your GitHub repository
3. Choose the following settings:
   - **Name**: my-mongodb-service
   - **Environment**: Docker
   - **Region**: Choose closest to your users
   - **Instance Type**: Free or Starter

#### Step 4: Configure Environment Variables
In the Render dashboard, add environment variables:
- `MONGO_INITDB_ROOT_USERNAME`: your_username
- `MONGO_INITDB_ROOT_PASSWORD`: your_password
- `MONGO_INITDB_DATABASE`: your_database

#### Step 5: Configure Persistent Storage
1. In your service settings, go to "Disks"
2. Click "Add Disk"
3. Set:
   - **Name**: mongodb-data
   - **Mount Path**: /data/db
   - **Size**: 1GB (or more depending on your plan)

#### Step 6: Expose the Port
Update your Dockerfile to use Render's PORT environment variable:
```dockerfile
FROM mongo:6.0
ENV MONGO_INITDB_ROOT_USERNAME=admin
ENV MONGO_INITDB_ROOT_PASSWORD=admin
ENV MONGO_INITDB_DATABASE=haki1234
EXPOSE 27017
```

In Render, the service will be accessible via a private URL provided by Render.

#### Step 7: Connect to Your Render MongoDB
Render will provide an internal URL like:
```
my-mongodb-service:27017
```

Use this in your connection string:
```
mongodb://username:password@my-mongodb-service:27017/database
```

**Important Notes for Render**:
- Free tier instances spin down after inactivity
- Use paid tier for production applications
- Configure automated backups in Render dashboard
- Monitor disk usage to avoid running out of space

### Enhancement 4: Health Checks

Add health checks to ensure MongoDB is running properly:

```yaml
version: "3.8"
services:
  mongo:
    image: mongo:6.0
    container_name: my_mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: securepassword123
      MONGO_INITDB_DATABASE: haki1234
    volumes:
      - ./mongodb-data:/data/db
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet
      interval: 10s
      timeout: 10s
      retries: 5
      start_period: 40s
```

**What this does**:
- Runs a ping command every 10 seconds
- Marks container unhealthy if ping fails 5 times
- Useful for orchestration and monitoring

### Enhancement 5: Multiple Databases

To support multiple databases and users:

#### Step 1: Create Initialization Script
Create `mongo-init.js`:
```javascript
db = db.getSiblingDB('database1');
db.createUser({
  user: 'user1',
  pwd: 'password1',
  roles: [{ role: 'readWrite', db: 'database1' }]
});

db = db.getSiblingDB('database2');
db.createUser({
  user: 'user2',
  pwd: 'password2',
  roles: [{ role: 'readWrite', db: 'database2' }]
});
```

#### Step 2: Update docker-compose.yml
```yaml
version: "3.8"
services:
  mongo:
    image: mongo:6.0
    container_name: my_mongo
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: securepassword123
    volumes:
      - ./mongodb-data:/data/db
      - ./mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro
```

The initialization script runs only once when the database is first created.

---

## Summary

You now have a complete MongoDB instance running in Docker! Here's a quick reference:

**Start MongoDB**:
```bash
docker-compose up -d
```

**Stop MongoDB**:
```bash
docker-compose down
```

**Connect**:
```
mongodb://admin:admin@localhost:27017/haki1234
```

**View Logs**:
```bash
docker-compose logs -f
```

**Backup Data**:
```bash
docker exec my_mongo mongodump --out=/backup
docker cp my_mongo:/backup ./backup
```

**Need Help?**
- Check the Troubleshooting section
- Review Docker logs
- Test connection from inside container first

Happy developing with MongoDB and Docker!