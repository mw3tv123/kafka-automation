#syntax=docker/dockerfile:experimental
# Build stage
FROM openjdk:11 AS builder
# Official repo for dashboard
RUN git clone https://github.com/yahoo/CMAK.git /app
WORKDIR /app
# Build
RUN ./sbt clean dist
# Unzip universal build
RUN cd target/universal && unzip cmak-*.zip

# Final stage
FROM adoptopenjdk/openjdk11:alpine-jre
# Alpine required for run shell script
RUN apk update && apk add bash
WORKDIR /app
COPY --from=builder /app/target/universal/cmak-* /app/
# Allow executing permission
RUN chmod +x /app/bin/cmak
CMD /app/bin/cmak
