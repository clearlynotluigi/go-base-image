ARG GO_VERSION

# cross-compiles for TARGETARCH
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS builder
ARG TARGETARCH
ARG GOLANG_MIGRATE_VERSION
ARG GO_DELVE_VERSION
RUN mkdir -p /out && \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go install -ldflags "-s -w" github.com/go-delve/delve/cmd/dlv@${GO_DELVE_VERSION} && \
    CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go install -ldflags "-s -w" -tags postgres github.com/golang-migrate/migrate/v4/cmd/migrate@${GOLANG_MIGRATE_VERSION} && \
    find /go/bin -type f -exec mv {} /out/ \;

FROM golang:${GO_VERSION}-alpine
ARG GOLANGCI_LINT_VERSION
ARG GOSEC_VERSION
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
    curl -sSfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b ${GOBIN} ${GOSEC_VERSION}

COPY --from=builder /out/ /usr/local/bin/
