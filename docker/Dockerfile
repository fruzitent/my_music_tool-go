# syntax=docker.io/docker/dockerfile:1.6-labs
# @help: https://docs.docker.com/reference/dockerfile

ARG WORKDIR="/workspaces/my_music_tool-go/"

FROM docker.io/library/golang:1.22-alpine3.19 as base

ARG WORKDIR
WORKDIR ${WORKDIR}

# hadolint ignore=DL3018
RUN --mount=type=cache,target=/var/cache/apk/,sharing=locked --mount=type=cache,target=/var/lib/apk/,sharing=locked <<EOF
    apk --update-cache add \
        "git" \
        "neovim" \
        ;
EOF

FROM base as deps

ARG WORKDIR
WORKDIR ${WORKDIR}

COPY "./go.mod" "${WORKDIR}/"
COPY "./go.sum" "${WORKDIR}/"

RUN --mount=type=cache,target=/go/,sharing=locked <<EOF
    go mod download
EOF

CMD ["sleep", "infinity"]

FROM deps as builder

ARG WORKDIR
WORKDIR ${WORKDIR}

COPY --from=deps "${WORKDIR}/go.mod" "${WORKDIR}/"
COPY --from=deps "${WORKDIR}/go.sum" "${WORKDIR}/"

COPY "./main.go" "${WORKDIR}/"

RUN <<EOF
    go build
EOF

# hadolint ignore=DL3006
FROM scratch as artifact

ARG WORKDIR

COPY --from=builder "${WORKDIR}/org.fruzitent.mymusictool" "/"

FROM docker.io/library/alpine:3.19 as runner

ARG WORKDIR
WORKDIR ${WORKDIR}

COPY --from=builder "${WORKDIR}/org.fruzitent.mymusictool" "/usr/local/bin/my_music_tool"

EXPOSE 8080

CMD ["/usr/local/bin/my_music_tool"]
