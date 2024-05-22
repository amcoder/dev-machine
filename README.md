# Dev Machine

This is a docker image that contains all necessary development tools.

## Build

```sh
docker build -t dev-machine .
```

## Run

```sh
cd /path/to/your/project
docker run --rm -v $(pwd):/home/dev/project -p [port]:[port] -it dev-machine
```

## Use as base image

```Dockerfile
FROM dev-machine

# Your Dockerfile
```
