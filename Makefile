GOVERSION=1.5
GOOS=linux
GOARCH=amd64

all: compacted-image run

image: go-lang tag

compacted-image: go-lang compact tag

clean:
	rm -f sample/bin/helloworld archives/go.tar.gz

# Download the go archive
archives/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz:
	mkdir -p archives
	curl -o archives/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz https://storage.googleapis.com/golang/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz

# stip the version number from the archive
archives/go.tar.gz: archives/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz
	rm -f archives/go.tar.gz
	cp archives/go${GOVERSION}.${GOOS}-${GOARCH}.tar.gz archives/go.tar.gz

# Create a docker container for the go language
go-lang: archives/go.tar.gz
	docker build -t ${USER}/go-lang .

compact:
	docker tag -f ${USER}/go-lang ${USER}/go-lang:uncompacted
	docker inspect --format '{{.State.Pid}}' go-lang-compacting >& /dev/null && docker rm -f go-lang-compacting || true
	docker run --name go-lang-compacting ${USER}/go-lang:uncompacted version
	docker export go-lang-compacting | docker import - ${USER}/go-lang:compacted
	/bin/sh -c "echo FROM ${USER}/go-lang:compacted ; grep -E '^(WORKDIR |VOLUME |ENTRYPOINT |CMD |ENV )' Dockerfile" | docker build --rm --no-cache -t ${USER}/go-lang -
	docker rm go-lang-compacting
	docker rmi ${USER}/go-lang:uncompacted ${USER}/go-lang:compacted

tag:
	docker tag -f ${USER}/go-lang ${USER}/go-lang:${GOVERSION}

sample/bin/helloworld: sample/src/helloworld.go
	cd sample && docker run --rm -e USER=${USER} -v `pwd`/bin:/go/bin -v `pwd`/src/:/go/src/github.com/${USER}/helloworld ${USER}/go-lang:${GOVERSION} install github.com/${USER}/helloworld

sample: sample/bin/helloworld
	cd sample && docker build -t ${USER}/helloworld .

run: sample
	docker run --rm ${USER}/helloworld
