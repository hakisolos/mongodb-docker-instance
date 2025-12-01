FROM mongo:4.4


ENV MONGO_USERNAME=admin
ENV MONGO_PASSWORD=admin
ENV MONGO_DATABASE_NAME=haki1234
#p
CMD ["mongod", "--bind_ip_all", "--sslMode", "disabled", "--quiet"]


EXPOSE 27017

