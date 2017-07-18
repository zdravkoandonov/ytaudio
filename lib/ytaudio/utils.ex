defmodule Ytaudio.Utils do
  @doc ~S"""
  Encodes request body

  Concatenates all given keys and values into a proper query of get parameters

  ## Examples

      iex> Ytaudio.Utils.encode_body %{a: "1", b: "2", c: "3"}
      "a=1&b=2&c=3"

      iex> Ytaudio.Utils.encode_body %{key: "AIzaSyBCUUOihvICOL8DiSP3gB3DxEGqz3JeALU", part: "snippet", playlistId: "PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw"}
      "key=AIzaSyBCUUOihvICOL8DiSP3gB3DxEGqz3JeALU&part=snippet&playlistId=PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw"

  """
  def encode_body(query) do
    Enum.map_join query, "&", fn x ->
      pair(x)
    end
  end

  defp pair({key, value}) do
    if Enumerable.impl_for(value) do
      pair(to_string(key), [], value)
    else
      param_name = key |> to_string |> URI.encode
      param_value = value |> to_string |> URI.encode

      "#{param_name}=#{param_value}"
    end
  end

  defp pair(root, parents, values) do
    Enum.map_join values, "&", fn {key, value} ->
      if Enumerable.impl_for(value) do
        pair(root, parents ++ [key], value)
      else
        build_key(root, parents ++ [key]) <> to_string(value)
      end
    end
  end

  defp build_key(root, parents) do
    path = Enum.map_join parents, "", fn x ->
      param = x |> to_string |> URI.encode
      "[#{param}]"
    end

    "#{root}#{path}="
  end
end
