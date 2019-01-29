# MQTT Client

This minimal Alpine-based image contains the two [mosquitto] clients for sending
data to topics and subscribing to topics. The image exposes a volume at
`/opt/certs` where CA certificates and/or client certificates can be placed for
trusted communication to a remote server. However, the image also comes with the
list of root certificates published by Mozilla, meaning that you should be able
to connect to remote servers that signed by one of the main authorities.

  [mosquitto]: https://mosquitto.org/

As the binaries are confined within a docker image, they are made accessible
through the shorthands `pub` and `sub` at the command line (in addition to
`mosquitto_pub` and `mosquitto_sub`). This allows for quicker interaction, such
as in the following command that would listen to all topics at the test
mosquitto server:

    docker run --init -it --rm efrecon/mqtt-client sub \
            -h test.mosquitto.org -t "#" -v

To connect to a TLS secure server, you could run a command similar to the one
below instead:

    docker run --init -it --rm efrecon/mqtt-client sub \
            -h iot.eclipse.org -p 8883 --capath /etc/ssl/certs -t "#" -v

## Technical Notes

The mosquitto code will not properly recognise the certificate bundles unless
they are rehashed. This is achieved through calling
`/etc/ca-certificates/update.d/certhash` as part of the image construction.