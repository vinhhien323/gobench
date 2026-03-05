FROM golang:1.5
# Pre-install glock at an early commit (3419eed) that has no external deps and
# therefore builds cleanly under Go 1.5.  The Makefile .bootstrap target tries
# `go get github.com/robfig/glock`, which fails on Go 1.5 because the current
# HEAD of glock depends on golang.org/x/mod (introduced with Go modules in 1.11).
RUN git clone https://github.com/robfig/glock.git /go/src/github.com/robfig/glock && \
    cd /go/src/github.com/robfig/glock && \
    git checkout 3419eed && \
    go install github.com/robfig/glock

# Clone the project to local
RUN git clone https://github.com/cockroachdb/cockroach.git /go/src/github.com/cockroachdb/cockroach




WORKDIR /go/src/github.com/cockroachdb/cockroach

# Rollback to the latest bug-free version
RUN git reset --hard 7174fe531297b2e2ff5f3b811c3646d6819bc990

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/cockroachdb/cockroach/bug_patch.diff
RUN sed -i 's/\r$//' github.com/cockroachdb/cockroach/bug_patch.diff && \
    git apply github.com/cockroachdb/cockroach/bug_patch.diff

# Pred-build
RUN sed -i '87s/"\$\$DIR"\/"\$\$OUT"/\/go\/gobench.test/' Makefile

# Build
RUN make testbuild TESTFLAGS=-race PKG=./gossip

# For entrypoint
WORKDIR /go/src/github.com/cockroachdb/cockroach/./gossip
