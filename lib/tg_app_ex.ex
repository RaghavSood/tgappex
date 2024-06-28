defmodule TGAppEx do
  @moduledoc """
  A library for validating and parsing Telegram Web App Init Data.
  """

  @doc """
  Validates the Telegram Web App Init Data.

  Returns {:ok, decoded_map} if the data is valid, and :error otherwise.

  ## Examples
      iex> init_data = "user=%7B%22id%22%3A301401270%2C%22first_name%22%3A%22Raghav%22%2C%22last_name%22%3A%22Sood%22%2C%22username%22%3A%22RaghavSood%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&chat_instance=3088182267291974857&chat_type=private&auth_date=1719548875&hash=8d08252f8da1fb386ad686a27ea51980b9e7c4898dd51595418a579cc2825ca4"
      iex> bot_api_token = "7249749463:AAF47pE6-3XqBcqw11uzeIRA2Mr4Obl9JvU"
      iex> TGAppEx.validate(init_data, bot_api_token)
      {:ok, %{"user" => %{"id" => 301401270, "first_name" => "Raghav", "last_name" => "Sood", "username" => "RaghavSood", "language_code" => "en", "is_premium" => true, "allows_write_to_pm" => true}, "chat_instance" => "3088182267291974857", "chat_type" => "private", "auth_date" => 1719548875}}

      iex> invalid_data = "user=%7B%22id%22%3A301401270%2C%22first_name%22%3A%22Raghav%22%2C%22last_name%22%3A%22Sood%22%2C%22username%22%3A%22RaghavSood%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&chat_instance=3088182267291974857&chat_type=private&auth_date=1719548875&hash=9d08252f8da1fb386ad686a27ea51980b9e7c4898dd51595418a579cc2825ca4"
      iex> bot_api_token = "7249749463:AAF47pE6-3XqBcqw11uzeIRA2Mr4Obl9JvU"
      iex> TGAppEx.validate(invalid_data, bot_api_token)
      :error
  """
  def validate(tg_init_data, bot_api_token) do
    {received_hash, decoded_map} = 
      tg_init_data
      |> URI.decode_query()
      |> Map.pop!("hash")

    data_check_string =
      decoded_map
      |> Enum.sort(fn {k1, _v1}, {k2, _v2} -> k1 <= k2 end)
      |> Enum.map_join("\n", fn {k, v} -> "#{k}=#{v}" end)

    calculated_hash =
      "WebAppData"
      |> hmac(bot_api_token)
      |> hmac(data_check_string)
      |> Base.encode16(case: :lower)

    if received_hash == calculated_hash do
      decoded_map = parse_values(decoded_map)
      {:ok, decoded_map}
    else
      :error
    end
  end

  @doc """
  Parses the Telegram Web App Init Data. This does NOT validate the signature. Use `validate/2` for that.
  """
  def parse(tg_init_data) do
    tg_init_data
    |> URI.decode_query()
    |> Map.delete("hash")
    |> parse_values()
  end

  defp hmac(key, data) do
    :crypto.mac(:hmac, :sha256, key, data)
  end

  defp parse_values(map) do
    map
    |> Enum.map(fn {key, value} ->
      case key do
        "user" -> {key, Jason.decode!(value)}
        "receiver" -> {key, Jason.decode!(value)}
        "chat" -> {key, Jason.decode!(value)}
        "auth_date" -> {key, String.to_integer(value)}
        "can_send_after" -> {key, String.to_integer(value)}
        _ -> {key, value}
      end
    end)
    |> Enum.into(%{})
  end
end
