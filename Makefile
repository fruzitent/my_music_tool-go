.PHONY: all
all: clean .WAIT build

.PHONY: build
build:
	go build

.PHONY: clean
clean:
	go clean

.PHONY: docker
docker:
	docker buildx build . \
		--file "./docker/Dockerfile" \
		--output "dest=./,type=local" \
		--tag "ghcr.io/fruzitent/my_music_tool-go:latest" \
		--target "artifact" \
		;

.PHONY: install
install:
