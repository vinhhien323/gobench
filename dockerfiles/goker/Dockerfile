# We use ubuntu:18.04 for GoKer evaluation because the dependencies of dingo-hunter
# relies on ubuntu:18.04. The result should not be affected because we use the same
# Go compiler (i.e. go:1.14)
FROM ubuntu:18.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y git vim wget haskell-platform python graphviz zlib1g-dev xz-utils pkg-config
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz && \
    tar -xf cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz && \
    mv cabal /usr/local/bin/cabal && \
    rm cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
RUN cabal v1-update && cabal v1-install network-2.8.0.1 MissingH-1.4.3.0 split Graphalyze


RUN wget https://dl.google.com/go/go1.14.11.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.14.11.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go/"

RUN go get -v -u github.com/nickng/migo && \
    go get -v -u github.com/nickng/dingo-hunter || \
    cd $GOPATH/src/github.com/nickng/dingo-hunter && go test -v . && \
    go install github.com/nickng/dingo-hunter
RUN cd $GOPATH/src/github.com/nickng/dingo-hunter && \
    git submodule init && git submodule update && \
    cd third_party/gmc-synthesis && \
    wget https://www.cs.upc.edu/~jordicf/petrify/distrib/petrify-5.2-linux.tar.gz && \
    tar -xvf petrify-5.2-linux.tar.gz && \
    ghc -threaded GMC.hs --make && ghc --make BuildGlobal
ENV PATH="/go/src/github.com/nickng/dingo-hunter/third_party/gmc-synthesis/petrify/bin:${PATH}"

RUN git clone https://github.com/nickng/gong.git && cd gong && cabal install
ENV PATH="/gong/dist/build/Gong:/go/bin:${PATH}"

RUN apt install -y make rsync python3 python3-pip python3-matplotlib
RUN go get golang.org/x/tools/cmd/goimports && \
    go get github.com/sasha-s/go-deadlock && \
    go get go.uber.org/goleak

RUN pip3 install -U pandas numpy==1.15.4

WORKDIR /root/gobench