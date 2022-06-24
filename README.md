> This repository has been archived. It has been superseded by https://hub.docker.com/_/rust


# Rust toolchain on Docker

### Usage as CLI

#### As a CLI

docker run --rm --tty --user "$(id -u):$(id -g)" --volume $(pwd):$(pwd) --workdir $(pwd) -e "USER=$(id -un)" loganmzz/rust cargo test

### Usage as builder pattern

#### Create a "build" image

Create a `Dockerfile.build` file:

```Dockerfile

FROM loganmzz/rust

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

#### Run image into a new container

```bash

docker run --name myproject-build-cont myproject-build-img ls -alF

```

#### Retrieve output

```bash

docker cp myproject-build-cont:/home/rust/myproject/target target

```

## Development

Image is automatically build from Docker Hub. However, genenerated image can be tested with [bats](https://github.com/bats-core/bats-core/).

```bash

bats tests/

```
