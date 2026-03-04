FROM golang:1.13
# Clone the project to local
RUN git clone https://github.com/moby/moby.git /go/src/github.com/moby/moby




WORKDIR /go/src/github.com/moby/moby

# Rollback to the latest bug-free version
RUN git reset --hard f10a222de1cc756bb14d157b778d820fac3561aa

# Apply the revert patch to this bug
COPY ./bug_patch.diff github.com/moby/moby/bug_patch.diff
RUN git apply github.com/moby/moby/bug_patch.diff

# Pred-build
RUN sed -i '47s/--rm//' Makefile && \
    sed -i '47s/MOUNT)/MOUNT) -v \/go\/test:\/go\/test --name moby_22941_cntr/' Makefile && \
    sed -i 's/p80.pool.sks-keyservers.net/keyserver.ubuntu.com/g' Dockerfile && \
    sed -i '/llvm.org/d' Dockerfile && \
    sed -i 's/clang-3.8/clang/g' Dockerfile && \
    sed -i 's/clang++-3.8/clang++/g' Dockerfile && \
    sed -i 's/storage.googleapis.com\/golang/dl.google.com\/go/g' Dockerfile && \
    sed -i '/docker-py/,/test-requirements/d' Dockerfile && \
    sed -i 's@RUN apt-get update \&\& apt-get install -y apt-transport-https ca-certificates@RUN sed -i "s|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g" /etc/apt/sources.list \&\& sed -i "/jessie-updates/d" /etc/apt/sources.list \&\& apt-get -o Acquire::Check-Valid-Until=false update \&\& apt-get install -y apt-transport-https ca-certificates@g' Dockerfile && \
    sed -i 's@RUN sed -i s/httpredir.debian.org/\$APT_MIRROR/g /etc/apt/sources.list@RUN sed -i s/httpredir.debian.org/\$APT_MIRROR/g /etc/apt/sources.list \&\& sed -i "s|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /jessie-updates/d" /etc/apt/sources.list@g' Dockerfile && \
    sed -i 's/apt-get update/apt-get -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true update/g' Dockerfile && \
    sed -i 's/apt-get install -y/apt-get install -y --allow-unauthenticated/g' Dockerfile && \
    sed -i 's/\&\& pip install awscli==1.10.15//g' Dockerfile && \
    sed -i 's|go get -v -d github.com/cpuguy83/go-md2man|git clone --depth 1 https://github.com/shurcooL/sanitized_anchor_name.git "\$GOPATH/src/github.com/shurcooL/sanitized_anchor_name"|g' Dockerfile && \
    sed -i '26s/\$COVER //' hack/make/test-unit && \
    sed -i '26s/go test.*/&\n\t&/' hack/make/test-unit && \
    sed -i '26s/$/ -i/' hack/make/test-unit && \
    sed -i '27s/\$pkg_list//' hack/make/test-unit && \
    sed -i '27s/$/ -c -o \/go\/gobench.test/' hack/make/test-unit


# For entrypoint
WORKDIR /go/src/github.com/moby/moby/.
