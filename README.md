# 🐹 go-base

A small, generic Go image for CI and development: the official `golang` Alpine image plus the tools you reach for every day. Multi-arch (`amd64` and `arm64`), static builds by default, one Dockerfile.

## 📦 What's inside

| Tool | Why |
| --- | --- |
| [task](https://taskfile.dev) | task runner |
| [golangci-lint](https://golangci-lint.run) | linting and formatting |
| [gosec](https://github.com/securego/gosec) | security scanning |
| [delve](https://github.com/go-delve/delve) | debugger |
| `git`, `bash`, `curl`, `jq`, `yq`, `tini`, `tzdata`, `ca-certificates` | the usual runner basics |

Exact versions per Go version live in [`versions.yml`](versions.yml).

## 🚀 Usage

```sh
docker pull mariort/go-base:1.27
```

```dockerfile
FROM mariort/go-base:1.27
```

Tags: `1.27` always points at the latest build, `1.27-YYMMDD` (with `-1`, `-2`, ... for further builds the same day) is the dated build.

## ⚙️ Defaults

- `CGO_ENABLED=0`, `GOOS=linux`: static binaries, no C compiler.
- `GOBIN=/usr/local/bin`: tools are on the `PATH`.
- `GOCACHE=/go/go-build` and `GOMODCACHE=/go/pkg/mod`: mount these two for caching.
- `GOTOOLCHAIN=auto`: a newer toolchain is fetched if `go.mod` asks for one.

Everything is a plain environment variable, so any project can override it.

## 🔨 Build and push

Needs [task](https://taskfile.dev), podman, git and [yq](https://github.com/mikefarah/yq) (v4).

```sh
task build:1.27
task push:1.27
```

`task` lists everything else. Extra registries can go in a git-ignored `.local/registries.yml` with the same `registries:` list as `versions.yml`.
