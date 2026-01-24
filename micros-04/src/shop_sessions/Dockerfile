# ===== Build stage =====
FROM elixir:1.19-alpine AS builder

RUN apk add --no-cache build-base git python3

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod
RUN mix deps.compile

COPY priv priv
COPY lib lib
COPY assets assets

RUN mix compile
RUN mix assets.deploy
RUN mix release


# ===== Runtime stage =====
FROM alpine:3.23 AS runner

RUN apk add --no-cache libstdc++ openssl ncurses-libs ca-certificates bash

WORKDIR /app
ENV MIX_ENV=prod

RUN addgroup -S app && adduser -S app -G app
USER app

COPY --from=builder --chown=app:app /app/_build/prod/rel/shop_sessions ./

ENV PHX_SERVER=true \
    PORT=4000

EXPOSE 4000

# If you use DNS service names (docker-compose), set PHX_HOST accordingly
# ENV PHX_HOST=localhost

CMD ["bin/shop_sessions", "start"]