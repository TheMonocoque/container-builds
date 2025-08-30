FROM docker.io/library/alpine:3.22

ARG VERSION_LIBRDKAFKA=v2.10.1
ARG VERSION_ASTRAL_UV=0.8.14

RUN apk update && apk upgrade

RUN apk add build-base git bash curl
RUN apk add automake cmake zlib-dev bzip2-dev expat-dev openssl-dev

# Compile librdkafka
# RUN cd /home \
#     && git clone https://github.com/confluentinc/librdkafka.git \
#     && cd librdkafka \
#     && git checkout ${VERSION_LIBRDKAFKA} \
#     && ./configure && make && make install \
#     && cd /root && rm -rf /home/librdkafka

RUN curl --proto '=https' --tlsv1.2 \
    -LsSf \
    https://github.com/astral-sh/uv/releases/download/${VERSION_ASTRAL_UV}/uv-installer.sh | sh
ENV PATH="$PATH:/root/.local/bin"

# TODO: alpine cannot compile confluent-kafka
ARG PACKAGES="confluent-kafka"
RUN mkdir -p /root/workspace
RUN cd /root/workspace \
    && uv init kafkabuild \
    && cd kafkabuild \
    && uv add $PACKAGES


