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

Tool versions live in [`image.yml`](image.yml).

## 🚀 Usage

```sh
docker pull mariort/go-base:1.27
```

```dockerfile
FROM mariort/go-base:1.27
```

Tags: `1.27` always points at the latest build, and `1.27-YYMMDD` is that day's build, handy for pinning.

## ⚙️ Defaults

- `CGO_ENABLED=0`, `GOOS=linux`: static binaries, no C compiler.
- `GOBIN=/usr/local/bin`: tools are on the `PATH`.
- `GOCACHE=/go/go-build` and `GOMODCACHE=/go/pkg/mod`: mount these two for caching.
- `GOTOOLCHAIN=auto`: a newer toolchain is fetched if `go.mod` asks for one.

Everything is a plain environment variable, so any project can override it.

## 🔨 Build and push

Needs [task](https://taskfile.dev), podman, git and [yq](https://github.com/mikefarah/yq) (v4).

```sh
task build:1.27   # build the image for both architectures
task tag:1.27     # create the git tag 1.27 and push it, so the release has a history
task push:1.27    # push to the registries; refuses until the git tag is on origin
```

`task rebuild:1.27` builds from the past: it checks out the git tag in a temporary worktree and builds there. `task` lists everything else. Extra registries can go in a git-ignored `.local/registries.yml` with the same `registries:` list as `image.yml`.
