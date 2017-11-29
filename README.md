# Rust toolchain on Docker

## Usage as CLI

### As a CLI

docker run --rm --tty --user $(id -u) --volume $(pwd):$(pwd) --workdir $(pwd) loganmzz/rust:1.21.0 cargo test

## Usage as builder pattern

### Create a "build" image

Create a `Dockerfile.build` file:

```Dockerfile

FROM loganmzz/rust:1.21.0

COPY . /home/rust/myproject

USER root

RUN chown -R rust:rust /home/rust/myproject

USER rust

WORKDIR /home/rust/myproject

RUN cargo test && cargo build --release

```

Generates Docker image from "build" Docker file:

```bash

docker build -t myproject-build-img -f Dockerfile.build .

```

### Run image into a new container

```bash

docker run --name myproject-build-cont myproject-build-img ls -alF

```

### Retrieve output

```bash

docker cp myproject-build-cont:/home/rust/myproject/target target

```
