# MQTT Client

This minimal Alpine-based image contains the two
[mosquitto](https://mosquitto.org/) clients for sending data to topics and
subscribing to topics. The image exposes a volume at `/opt/certs` where CA
certificates and/or client certificates can be placed for trusted communication
to a remote server.

As the binaries are confined within a docker image, they are made accessible
through the shorthands `pub` and `sub` at the command line (in addition to
`mosquitto_pub` and `mosquitto_sub`). This allows for quicker interaction, such
as in the following command that would listen to all topics at the test
mosquitto server:

    docker run -it --rm efrecon/mqtt-client sub -h test.mosquitto.org -t "#" -v