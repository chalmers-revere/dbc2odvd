# dbc2odvd
This tool can be used during development to transform a .dbc file with CAN messages to corresponding messages in .odvd format.

## Building the Docker image
```
docker build -t dbc2odvd:latest -f Dockerfile.amd64
```

## Monitoring a SocketCAN network adapter
```
docker run --rm -ti --net=host -v /file/to/a/file.dbc:/file.dbc dbc2odvd:latest cantools monitor /file.dbc
```
