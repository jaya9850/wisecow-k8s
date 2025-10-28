     1  FROM ubuntu:20.04
     2  ENV DEBIAN_FRONTEND=noninteractive
     3  ENV PATH="/usr/games:${PATH}"
     4  WORKDIR /app
     5
     6  RUN apt-get update && apt-get install -y \
     7      fortune cowsay netcat dos2unix \
     8      && rm -rf /var/lib/apt/lists/*
     9
    10  COPY wisecow.sh /app/wisecow.sh
    11  RUN dos2unix /app/wisecow.sh && chmod +x /app/wisecow.sh
    12
    13  EXPOSE 4499
    14  CMD ["/app/wisecow.sh"]
    15
