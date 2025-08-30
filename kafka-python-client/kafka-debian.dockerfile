FROM docker.io/library/debian:bookworm

ARG VERSION_LIBRDKAFKA=v2.10.1
ARG VERSION_ASTRAL_UV=0.8.14

RUN apt update && apt upgrade \
    && apt install -y build-essential gcc make cmake wget curl \
    && apt install -y git libssl-dev zlib1g-dev libsqlite3-dev libbz2-dev

# Compile librdkafka
RUN cd /home \
    && git clone https://github.com/confluentinc/librdkafka.git \
    && cd librdkafka \
    && git checkout ${VERSION_LIBRDKAFKA} \
    && ./configure && make && make install \
    && cd /root && rm -rf /home/librdkafka

RUN curl --proto '=https' --tlsv1.2 \
    -LsSf \
    https://github.com/astral-sh/uv/releases/download/${VERSION_ASTRAL_UV}/uv-installer.sh | sh
ENV PATH="$PATH:/root/.local/bin"

RUN mkdir -p /root/workspace
ARG PACKAGES="confluent-kafka"
RUN cd /root/workspace \
    && uv init kafkabuild \
    && cd kafkabuild \
    && uv add $PACKAGES
