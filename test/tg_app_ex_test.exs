defmodule TgAppExTest do
  use ExUnit.Case
  doctest TGAppEx

  @bot_api_token "7249749463:AAF47pE6-3XqBcqw11uzeIRA2Mr4Obl9JvU"

  test "validates correct init data" do
    init_data = "user=%7B%22id%22%3A301401270%2C%22first_name%22%3A%22Raghav%22%2C%22last_name%22%3A%22Sood%22%2C%22username%22%3A%22RaghavSood%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&chat_instance=3088182267291974857&chat_type=private&auth_date=1719548875&hash=8d08252f8da1fb386ad686a27ea51980b9e7c4898dd51595418a579cc2825ca4"
    assert TGAppEx.validate(init_data, @bot_api_token) ==
      {:ok, %{
        "user" => %{
          "id" => 301401270,
          "first_name" => "Raghav",
          "last_name" => "Sood",
          "username" => "RaghavSood",
          "language_code" => "en",
          "is_premium" => true, 
          "allows_write_to_pm" => true
        },
        "chat_instance" => "3088182267291974857",
        "chat_type" => "private",
        "auth_date" => 1719548875
      }}
  end

  test "rejects invalid init data" do
    init_data = "user=%7B%22id%22%3A301401270%2C%22first_name%22%3A%22Raghav%22%2C%22last_name%22%3A%22Sood%22%2C%22username%22%3A%22RaghavSood%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&chat_instance=3088182267291974857&chat_type=private&auth_date=1719548875&hash=9d08252f8da1fb386ad686a27ea51980b9e7c4898dd51595418a579cc2825ca4"
    assert TGAppEx.validate(init_data, @bot_api_token) == :error
  end

  test "parses init data" do
    init_data = "user=%7B%22id%22%3A301401270%2C%22first_name%22%3A%22Raghav%22%2C%22last_name%22%3A%22Sood%22%2C%22username%22%3A%22RaghavSood%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&chat_instance=3088182267291974857&chat_type=private&auth_date=1719548875&hash=9d08252f8da1fb386ad686a27ea51980b9e7c4898dd51595418a579cc2825ca4"
    assert TGAppEx.parse(init_data) ==
      %{
        "user" => %{
          "id" => 301401270,
          "first_name" => "Raghav",
          "last_name" => "Sood",
          "username" => "RaghavSood",
          "language_code" => "en",
          "is_premium" => true,
          "allows_write_to_pm" => true
        },
        "chat_instance" => "3088182267291974857",
        "chat_type" => "private",
        "auth_date" => 1719548875
      }
  end
end

