FROM bitwalker/alpine-elixir-phoenix:latest
WORKDIR /app
COPY . /app

ENV MIX_ENV prod

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && chmod -R 777 /opt/app \
    && mix assets.deploy \
    && chmod -R 777 /app

CMD ["mix", "phx.server"]
