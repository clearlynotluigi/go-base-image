ARG GO_VERSION

FROM golang:${GO_VERSION}-alpine
ARG GOLANGCI_LINT_VERSION
ARG GOSEC_VERSION
ARG GO_DELVE_VERSION
ARG GO_VERSION
ARG TASK_VERSION

ENV CGO_ENABLED=0 \
    GOBIN=/usr/local/bin \
    GOCACHE=/go/go-build \
    GOMODCACHE=/go/pkg/mod \
    GOOS=linux \
    GOTOOLCHAIN=auto

RUN apk add --no-cache bash ca-certificates curl git jq tini tzdata yq-go && \
    git config --system --add safe.directory '*'

RUN sh -c "$(curl -sSfL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin ${TASK_VERSION} && \
    curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b ${GOBIN} ${GOLANGCI_LINT_VERSION} && \
    curl -sSfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b ${GOBIN} ${GOSEC_VERSION} && \
    go install -ldflags "-s -w" github.com/go-delve/delve/cmd/dlv@${GO_DELVE_VERSION} && \
    go clean -cache -modcache
