FROM buildpack-deps:stretch-scm

LABEL maintainer="Logan Mzz"

ENV RUST_VERSION 1.21.0

RUN apt update \
    && apt install -y dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r rust && useradd -r -g rust -m rust

USER rust

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}

ENV PATH /home/rust/.cargo/bin:$PATH

ENV HOME /home/rust
