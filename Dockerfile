FROM buildpack-deps:stretch-scm

ARG RUST_RELEASE_VERSION=1.30.1
ARG RUST_RELEASE_DATE=2018-11-08

LABEL maintainer="Logan Mzz"

LABEL org.rust-lang.version=${RUST_RELEASE_VERSION}
LABEL org.rust-lang.channel="stable"
LABEL org.rust-lang.release-date=${RUST_RELEASE_DATE}

ENV RUST_VERSION ${RUST_RELEASE_VERSION}

RUN apt update \
    && apt install -y dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r rust && useradd -r -g rust -m rust

USER rust

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain "${RUST_VERSION}"

ENV PATH /home/rust/.cargo/bin:$PATH

ENV HOME /home/rust
