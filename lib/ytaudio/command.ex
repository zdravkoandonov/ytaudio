defmodule Ytaudio.Server.Command do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> Ytaudio.Server.Command.parse "dl video ul0BYPRu_jY\r\n"
      {:ok, {:dl_video, "ul0BYPRu_jY"}}

      iex> Ytaudio.Server.Command.parse "dl playlist PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw\r\n"
      {:ok, {:dl_playlist, "PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw"}}

      iex> Ytaudio.Server.Command.parse "detail video ul0BYPRu_jY\r\n"
      {:ok, {:detail_video, "ul0BYPRu_jY"}}

      iex> Ytaudio.Server.Command.parse "detail playlist PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw\r\n"
      {:ok, {:detail_playlist, "PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw"}}

      iex> Ytaudio.Server.Command.parse "search video cooking\r\n"
      {:ok, {:search_video, "cooking"}}

      iex> Ytaudio.Server.Command.parse "search playlist cooking\r\n"
      {:ok, {:search_playlist, "cooking"}}

      iex> Ytaudio.Server.Command.parse "list playlist PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw\r\n"
      {:ok, {:list_playlist, "PL7Vr8XNhXsJAKgFY8jlTUAgiMDByR3oaw"}}

      iex> Ytaudio.Server.Command.parse "recommend video ul0BYPRu_jY\r\n"
      {:ok, {:recommend, "ul0BYPRu_jY"}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

      iex> Ytaudio.Server.Command.parse "download all videos\r\n"
      {:error, :unknown_command}

  """
  def parse(line) do
    case String.strip(line) |> String.split(" ", parts: 3) do
      ["dl", "video", video_id] -> {:ok, {:dl_video, video_id}}
      ["dl", "playlist", playlist_id] -> {:ok, {:dl_playlist, playlist_id}}
      ["detail", "video", video_id] -> {:ok, {:detail_video, video_id}}
      ["detail", "playlist", playlist_id] -> {:ok, {:detail_playlist, playlist_id}}
      ["search", "video", search_term] -> {:ok, {:search_video, search_term}}
      ["search", "playlist", search_term] -> {:ok, {:search_playlist, search_term}}
      ["list", "playlist", playlist_id] -> {:ok, {:list_playlist, playlist_id}}
      ["recommend", "video", video_id] -> {:ok, {:recommend, video_id}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:dl_video, video_id}) do
    Ytaudio.Downloader.download_single_audio(video_id)
    {:ok, "OK\n\n"}
  end

  def run({:dl_playlist, playlist_id}) do
    {:ok, video_ids} = Ytaudio.Ytdata.list_playlist_video_ids(playlist_id)
    IO.inspect video_ids
    Ytaudio.Downloader.download_playlist(video_ids)
    {:ok, "OK\n\n"}
  end

  def run({:detail_video, video_id}) do
    {:ok, result} = Ytaudio.Ytdata.detail_video(video_id)
    {:ok, [result, "OK\n\n"]}
  end

  def run({:detail_playlist, playlist_id}) do
    {:ok, result} = Ytaudio.Ytdata.detail_playlist(playlist_id)
    {:ok, [result, "OK\n\n"]}
  end

  def run({:search_video, search_term}) do
    {:ok, search_results} = Ytaudio.Ytdata.search_by_query(:video, search_term)
    {:ok, [search_results, "OK\n\n"]}
  end

  def run({:search_playlist, search_term}) do
    {:ok, search_results} = Ytaudio.Ytdata.search_by_query(:playlist, search_term)
    {:ok, [search_results, "OK\n\n"]}
  end

  def run({:list_playlist, playlist_id}) do
    {:ok, result} = Ytaudio.Ytdata.list_playlist(playlist_id)
    {:ok, [result, "OK\n\n"]}
  end

  def run({:recommend, video_id}) do
    {:ok, result} = Ytaudio.Ytdata.recommend(video_id)
    {:ok, [result, "OK\n\n"]}
  end
end
