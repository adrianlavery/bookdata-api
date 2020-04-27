FROM golang:1.14.2-alpine

ENV GOPATH=/go
ENV GO111MODULE=on

# Install git - required for vscode & go get
# Install dependencies for debugging (gcc/g++/libc6-compat)
# Install docker cli for building the container
RUN apk update && apk add --no-cache \
    git \
    gcc g++ libc6-compat \
    docker-cli

## Install Golang analysis tools
RUN go get -v golang.org/x/tools/gopls@latest && \
    go get -v github.com/go-delve/delve/cmd/dlv@latest && \
    go get -v golang.org/x/lint/golint@latest && \
    go get -v golang.org/x/tools/cmd/gorename@latest && \
    go get -v golang.org/x/tools/cmd/guru@latest && \
    go get -v github.com/stamblerre/gocode && \
    cp /go/bin/gocode /go/bin/gocode-gomod && \
    go get -v github.com/newhook/go-symbols@latest && \
    go get -v github.com/ramya-rao-a/go-outline@latest && \
    go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && \
    go get -v github.com/stamblerre/gocode@latest && \
    go get -v github.com/rogpeppe/godef@latest && \
    go get -v github.com/sqs/goreturns@latest



# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]