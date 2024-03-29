# This file has been automatically generated from the binenv.{sh,tpl} pair of
# files in the same directory on %DATE%
# Based on version at: %COMMIT%
name: %DISTRIBUTION%

on:
  workflow_dispatch:
  push:
    branches:
      - 'master'
      - 'feature/binenv'
    paths:
      - 'binenv/**'
      - '.github/workflows/%DISTRIBUTION%.yml'
  schedule:
      - cron: "0 0 * * *"

env:
  SOURCE_COMMIT: ${{ github.sha }}
  MIN_VERSION: "0.0.1"

jobs:
  %DISTRIBUTION%:
    runs-on: ubuntu-latest
    steps:
      -
        name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: true
      -
        name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GITHUB_TOKEN }}
      -
        name: Build GHCR images
        env:
          DOCKER_REPO: ghcr.io/efrecon/%DISTRIBUTION%
        run: cd binenv/distribution && ./build
      -
        name: Push GHCR images
        env:
          DOCKER_REPO: ghcr.io/efrecon/%DISTRIBUTION%
        run: cd binenv/distribution && ./push
