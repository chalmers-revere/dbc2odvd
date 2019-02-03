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

## Generate a header-only library to decode/encode CAN frames into ODVD messages
Pre-conditions:
* A .dbc file (eg. `myFile.dbc`) is present in the current working directory.
* A .odvd file (eg. `myFile.odvd`) is present in the current working directory.

This output will be generated into `myFile.hpp` and `myFile.dbc.map`.
```
docker run --rm -ti -v $PWD:/in -w /in dbc2odvd:latest generateHeaderOnly.sh myFile.dbc myFile.odvd
```

The file `myFile.dbc.map` is a simple list of signals from the dbc file followed
by a colon; you need to add a mapping entry to an existing ODVD message for those
CAN signals that are of interest. Example:
```
fh16gw_vehicle_dynamics_t.acceleration_x:opendlv.proxy.rhino.VehicleState.accelerationX
fh16gw_vehicle_dynamics_t.acceleration_y:opendlv.proxy.rhino.VehicleState.accelerationY
fh16gw_vehicle_dynamics_t.yaw_rate:opendlv.proxy.rhino.VehicleState.yawRate
```

Afterwards, continue with the last step to generate the code snippet that
runs the actual mapping.

## Generate the code snippet to map ODVD messages to/from CAN frames
Pre-conditions:
* A .dbc.map file.

This output will be printed to stdout and can be directly added to you code.
```
docker run --rm -ti -v $PWD:/in -w /in dbc2odvd:latest generateMappingCodeSnippet.awk myFile.dbc.map
```

The code snippet can be invoked to pass raw CAN frame data using the following
interface:

```cpp
inline void decode(uint16_t canFrameID, uint8_t *buffer, uint8_t len);
```

The code snippet contains also template code that is useful for mapping
incoming ODVD messages to CAN frames in the following interface:

```cpp
inline int encode(uint8_t *dst, uint8_t len);
```

However, the code to map high-level ODVD messages to low-level CAN frames
requires some more logic to glue the actual template code to the ODVD message
handling, the encode method is not directly useful but shall rather serve as
illustration.


