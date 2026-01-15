FROM golang:1.14

RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN apt update && apt install -y vim rsync python3 python3-pip python3-matplotlib

RUN pip3 install pandas numpy

# Enable modules to install specific versions
ENV GO111MODULE=on

# Install specific versions compatible with Go 1.14 (approx. year 2020/2021)
# v0.1.0 is one of the last x/tools versions to support older Go
RUN go get golang.org/x/tools/cmd/goimports@v0.1.0 && \
    go get github.com/sasha-s/go-deadlock@v0.2.0 && \
    go get go.uber.org/goleak@v1.1.10


ENV PATH=/go/bin:${PATH}


WORKDIR /root/gobench