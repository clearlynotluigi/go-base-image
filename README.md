# go-base

A generic Go image for CI and development: the official `golang`. Multi-arch (`amd64` and `arm64`). Tool versions live in `image.yml`.

## Build and publish

The tag is the Go version, plus an optional revision when only the recipe changed: `1.27`, `1.27-r2`, `1.27-r3`. Every tag is pushed once and never reused.

```sh
task build:1.x   # build for both architectures
task tag:1.x     # create the git tag and push it
task push:1.x    # push to the registries (needs the git tag on origin)
```
