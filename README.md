# Rust toolchain on Docker

## Usage

1. Create a "build" image

```Dockerfile
# Dockerfile.build
FROM loganmzz/rust:1.21.0

COPY . /home/rust/myproject

RUN chown -R rust:rust /home/rust/myproject

WORKDIR /home/rust/myproject

RUN cargo test && cargo build --release
```

```bash
docker build -t myproject-build-img -f Dockerfile.build .
```

2. Run image into a new container

```bash
docker run --name myproject-build-cont myproject-build-img ls -alF
```

3. Retrieve output

```bash
docker cp myproject-build-cont:/home/rust/myproject/target target
```
