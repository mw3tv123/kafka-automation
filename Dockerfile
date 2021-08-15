#syntax=docker/dockerfile:experimental
FROM openjdk:11 AS builder
RUN git clone https://github.com/yahoo/CMAK.git /app
WORKDIR /app
RUN ./sbt clean dist
RUN cd target/universal && unzip cmak-*.zip
RUN ls -la target/universal/cmak-*

FROM adoptopenjdk/openjdk11:alpine-jre
RUN apk update && apk add bash
WORKDIR /app
COPY --from=builder /app/target/universal/cmak-* /app/
RUN chmod +x /app/bin/cmak
CMD /app/bin/cmak
