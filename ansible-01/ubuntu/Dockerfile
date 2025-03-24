FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    ln -sf python3 /usr/bin/python && \
    apt-get clean
CMD ["sleep", "infinity"]