FROM mongo:6.0

ENV MONGO_USERNAME=admin
ENV MONGO_PASSWORD=admin
ENV MONGO_DATABASE_NAME=haki1234
#
CMD ["mongod", "--bind_ip_all", "--sslMode", "disabled"]

EXPOSE 27017