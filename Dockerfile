# Use official MongoDB image
FROM mongo:7.0

# Expose MongoDB port
EXPOSE 27017

# Optional: set environment variables for root user
ENV MONGO_INITDB_ROOT_USERNAME=hakisolos
ENV MONGO_INITDB_ROOT_PASSWORD=hakisolos
