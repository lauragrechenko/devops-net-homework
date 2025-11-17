import sentry_sdk

sentry_sdk.init(
    dsn="https://8a01fe2a....@o4510380816465920.ingest.de.sentry.io/4510381271679056",
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
    send_default_pii=True,
)

sentry_sdk.capture_message("Hello from my test script")

# division_by_zero = 100 / 0