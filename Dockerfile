FROM alpine:edge
RUN apk --no-cache -U upgrade
RUN apk --no-cache add make m4 opam
RUN addgroup -S group1 && adduser -S user1 -G group1

USER user1
RUN mkdir -p /home/user1/work
WORKDIR /home/user1/work
RUN opam init --disable-sandboxing # See https://github.com/ocaml/opam/issues/3498
RUN echo 'eval $(opam config env)' >> /home/user1/.profile

USER root
RUN apk --no-cache add musl-dev perl g++

USER user1
RUN mkdir -p /home/user1/work
WORKDIR /home/user1/work
RUN opam switch -y create . 4.07.1
RUN opam install -y opam-lock

USER root
RUN apk --no-cache add pkgconfig python2 cmake sqlite-dev llvm5-dev

USER user1
RUN opam install -y \
  base=v0.11.1 \
  dune=1.5.1 \
  llvm=5.0.0 \
  menhir=20181113 \
  sedlex=1.99.3 \
  sqlite3=4.4.1 \
  toml=5.0.0
