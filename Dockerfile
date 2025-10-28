FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"

WORKDIR /app

RUN apt-get update && apt-get install -y \
    fortune cowsay netcat dos2unix \
    && rm -rf /var/lib/apt/lists/*

COPY wisecow.sh /app/wisecow.sh
RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh

EXPOSE 4499
CMD ["/app/wisecow.sh"]
