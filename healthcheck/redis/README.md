# Effortless HEALTHCHECK capable redis

This image is to capture all possible (now, then and future) tags of the redis
image and to arrange for creating an equivalent image with the same tag, but
HEALTHCHECK-capabities built in.

## Docker Cloud Settings

Create an automated build on the docker cloud with a tag source similar to

    /^redis-([0-9.]+(-alpine)?)$/

and a docker tag of

    {\1}

The docker tag will extract away the leading `redis-` and this will be passed to
the build hook, which will further gives this to the docker build context as a
build argument called `SRCTAG` to later automatically create an image with the
same tag.

## Creating the Tags

It is just then a matter to follow the tagging of the official image by tagging your git project as:

    git tag redis-4.0.6-alpine
    git push origin --tags

## Removing the Tags

    git tag -d redis-4.0.6-alpine
    git push origin :refs/tags/redis-4.0.6-alpine