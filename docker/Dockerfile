# syntax=docker/dockerfile:1.6-labs

ARG WORKDIR="/workspaces/my_music_tool-go/"

FROM docker.io/library/golang:1.22-alpine3.19 as deps

ARG WORKDIR
WORKDIR ${WORKDIR}

COPY "./go.mod"  "${WORKDIR}/"
COPY "./go.sum"  "${WORKDIR}/"

RUN --mount=type=cache,target=/root/go/,sharing=locked <<EOF
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

FROM docker.io/library/alpine:3.19 as runner

ARG WORKDIR
WORKDIR ${WORKDIR}

COPY --from=builder "${WORKDIR}/org.fruzitent.mymusictool" "/usr/local/bin/my_music_tool"

EXPOSE 8080

CMD ["/usr/local/bin/my_music_tool"]
