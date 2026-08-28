#!/bin/sh

# tag::build[]
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t bmatthews68/skaffold:1.0.0 \
  -t bmatthews68/skaffold:latest \
  --push \
  .
# end::build[]
