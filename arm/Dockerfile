FROM golang:1.20.5-buster AS sdlfoxbuilder
RUN sed -i 's#deb.debian#archive.debian#' /etc/apt/sources.list

RUN apt update && apt install -y make build-essential libsdl2-dev libfontconfig-dev libfreetype6-dev
WORKDIR /app
RUN git clone https://github.com/palomena/SDL_fox
WORKDIR /app/SDL_fox
COPY arm.mk make/default.mk
RUN make
RUN make install
RUN apt install -y file
RUN file /app/SDL_fox/build/libsdlfox.so

FROM golang:1.20.5-buster
RUN sed -i 's#deb.debian#archive.debian#' /etc/apt/sources.list

ENV GOOS=linux
ENV GOARCH=arm
ENV CGO_ENABLED=1
ENV CROSS_COMPILE=arm-linux-gnueabihf-
ENV CC=arm-linux-gnueabihf-gcc

RUN apt update && apt install -y libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libtool-bin libfontconfig patch

ARG TERMSP_VERSION=5116aeda84b8d4bb125a214464c131c177260140
ENV TERMSP_VERSION=$TERMSP_VERSION

RUN git clone https://github.com/Nevrdid/TermSP /go/src/github.com/Nevrdid/TermSP && \
    git -C /go/src/github.com/Nevrdid/TermSP checkout "$TERMSP_VERSION"

# RUN apt install -y libunicode

WORKDIR /go/src/github.com/Nevrdid/TermSP
COPY --from=sdlfoxbuilder /app/SDL_fox/build/libsdlfox.so /go/src/github.com/Nevrdid/TermSP/libs/libsdlfox.so
RUN cd libvterm-0.3.3 && make
RUN mkdir -p build && make all

RUN apt-get update && apt-get install -y file

RUN ls -lah /go/src/github.com/Nevrdid/TermSP/build
RUN file /go/src/github.com/Nevrdid/TermSP/build/TermSP
