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

