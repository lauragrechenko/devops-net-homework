defmodule ShopSessions.SessionStore do
  @moduledoc """
  Session store with read-through/write-through caching.

  - Read-through: get_user_by_token checks cache first, loads from DB on miss
  - Write-through: delete_session evicts from cache when deleting from DB

  Cache keys are hashed for security - raw tokens are not exposed in Redis.
  """
  use Nebulex.Caching
  require Logger

  alias ShopSessions.Cache
  alias ShopSessions.Accounts

  @ttl :timer.hours(24)

  @doc """
  Read-through cache for session tokens.
  Checks Redis first, falls back to database on cache miss.
  """
  @decorate cacheable(cache: Cache, key: cache_key(token), opts: [ttl: @ttl])
  def get_user_by_token(token) do
    # This code ONLY runs on cache miss!
    Logger.info("[SessionStore] CACHE MISS - querying DB for token: #{Base.encode16(token)}")
    result = Accounts.get_user_by_session_token(token)
    Logger.info("[SessionStore] DB result: #{inspect(result)}")
    result
  end

  @doc """
  Write-through cache eviction.
  Deletes from database and evicts from cache.
  """
  @decorate cache_evict(cache: Cache, key: cache_key(token))
  def delete_session(token) do
    Logger.info(
      "[SessionStore] DELETE session, evicting cache for token: #{Base.encode16(token)}"
    )

    Accounts.delete_user_session_token(token)
  end

  # Hash token for cache key - prevents raw token exposure in Redis
  defp cache_key(token), do: {:session, :crypto.hash(:sha256, token)}
end
