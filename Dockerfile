## Dockerfile
FROM bitwalker/alpine-elixir:1.7.4 as build
## install build dependencies
RUN apk add --update git
RUN apk --update upgrade
RUN apk add build-base

## prepare build dir
RUN mkdir /app
WORKDIR /app

## install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config ./
COPY priv/static ./priv/static/
# COPY deps ./
RUN mix deps.get
RUN mix deps.compile
RUN mix phoenix.digest

# build release
COPY . .
RUN mix release --no-tar --verbose

# prepare release image
FROM alpine:3.8
RUN apk add --update bash openssl
RUN apk add imagemagick

RUN mkdir /app && chown -R nobody: /app
WORKDIR /app
USER nobody

COPY --from=build /app/_build/prod/rel/siemens_collection ./

ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT ["/app/bin/siemens_collection"]
