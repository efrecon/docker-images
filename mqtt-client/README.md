# MQTT Client

This minimal Alpine-based [image] contains the two [mosquitto] clients [mosquitto_sub] and [mosquittto_pub] for
sending data to topics and subscribing to topics. The image exposes a volume at
`/opt/certs` where CA certificates and/or client certificates can be placed for
trusted communication to a remote server. However, the image also comes with the
list of root certificates published by Mozilla, meaning that you should be able
to connect to remote servers that are signed by one of the main authorities.

  [mosquitto_sub]:https://mosquitto.org/man/mosquitto_sub-1.html
  [mosquittto_pub]:https://mosquitto.org/man/mosquitto_pub-1.html
  [mosquitto]: https://mosquitto.org/
  [image]: https://hub.docker.com/r/efrecon/mqtt-client

As the binaries are confined within a docker image, they are made accessible
through the shorthands `pub` and `sub` at the command line (in addition to
`mosquitto_pub` and `mosquitto_sub`). This allows for quicker interaction, such
as in the following command that would listen to all topics at the test
mosquitto server `-v` prints out the actual payload recieved:

    docker run -it --rm efrecon/mqtt-client sub \
            -h test.mosquitto.org -t "#" -v

To connect to a TLS secure server, you could run a command similar to the one
below instead:

    docker run -it --rm efrecon/mqtt-client sub \
            -h iot.eclipse.org -p 8883 --capath /etc/ssl/certs -t "#" -v

To connect and publish data to topic `test/tesdevice` something like this could be used

    docker run -it --rm efrecon/mqtt-client pub \
            -d -h test.mosquitto.org -p 1883 -t "test/tesdevice" -m '[{"json":"validated","data":42},{"to":2,"test":"with"}]'

to publish more complex data from a file you need to mount access to local directories. 
ex to pass `./datafile.json`:

    docker run -it --rm -v ${PWD}:/data/ efrecon/mqtt-client pub \
            -d -h test.mosquitto.org -p 1883 -t "test/tesdevice" -f /data/datafile.json

When problems occur the `-d` for debug is recommended to see the connection information 

In some systems it is important to provide a valid clientid to the MQTT server this can be 
done with `-i specialclientid` flag on the command-line

Clients can easily be interrupted from the command-line as they are placed
behind `tini` through the entrypoint of the image.

## docker on MAC

This image need to now that it is runing on another platform to be able to run on a MAC OSX

     docker run --platform linux/amd64

## Technical Notes

The mosquitto code will not properly recognise the certificate bundles unless
they are rehashed. This is achieved through calling
`/etc/ca-certificates/update.d/certhash` as part of the image construction.

Versioning follows the Alpine packages.
