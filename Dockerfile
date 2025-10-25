# Dockerfile for wisecow (Alpine, bash + fortune + cowsay)
FROM alpine:3.18

# install bash + fortune + cowsay
RUN apk add --no-cache bash fortune-mod cowsay

WORKDIR /app

# copy script
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# expose a port (script doesn't really use it but keep for k8s svc)
EXPOSE 4499

# prefer non-root where possible
RUN addgroup -S wisecow && adduser -S -G wisecow wisecow
USER wisecow

# run the script (it prints to stdout in a loop)
CMD ["/app/wisecow.sh"]
