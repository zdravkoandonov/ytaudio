defmodule Ytaudio.API do
  @doc """
  Returns the base URL for all requests to the YouTube Data API
  """
  def endpoint, do: "https://www.googleapis.com/youtube/v3"

  @doc """
  Returns the api key for the YouTube Data API set in the config file
  """
  def api_key do
    Application.get_env(:ytaudio, :api_key)
  end

  @doc """
  Sends an HTTP GET request with `url` address and `query` get parameters
  """
  def get(url, query \\ []) do
    HTTPoison.start
    query = Ytaudio.Utils.encode_body(query)

    unless String.length(query) == 0 do
      url = "#{url}?#{query}"
    end

    HTTPoison.get!(url, []) |> handle_response
  end

  defp handle_response(%HTTPoison.Response{body: body, status_code: code}) when code in 200..299 do
    {:ok, Poison.decode!(body)}
  end

  defp handle_response(%HTTPoison.Response{body: body, status_code: _}) do
    {:error, Poison.decode!(body)}
  end

end
