defmodule Ytaudio.Ytdata do

  @doc """
  Fetches details for video with id `video_id`.

  The video is represented as an IO list and has a title, a channel title, a publish date and a description.
  """
  def detail_video(video_id) do
    opts = %{key: Ytaudio.API.api_key, id: video_id, part: "snippet"}
    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/videos", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(:single_detail , &1))}
      err -> err
    end
  end

  @doc """
  Fetches details for playlist with id `playlist_id`.

  The playlist is represented as an IO list and has a title, a channel title, a publish date and a description.
  """
  def detail_playlist(playlist_id) do
    opts = %{key: Ytaudio.API.api_key, id: playlist_id, part: "snippet"}
    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/playlists", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(:single_detail , &1))}
      err -> err
    end
  end

  @doc """
  Fetch a list of videos on a playlist with id `playlist_id`.

  Every video is represented as an IO list and has a title, an id, a channel title and a publish date.
  """
  def list_playlist(playlist_id, opts \\ %{}) do
    defaults = %{key: Ytaudio.API.api_key, maxResults: 10, playlistId: playlist_id, part: "snippet"}
    opts = Map.merge(defaults, opts)

    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/playlistItems", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(:playlist_item, &1))}
      err -> err
    end
  end

  @doc """
  Fetch a list of the ids of videos on a playlist with id `playlist_id`.
  """
  def list_playlist_video_ids(playlist_id, opts \\ %{}) do
    defaults = %{key: Ytaudio.API.api_key, maxResults: 10, playlistId: playlist_id, part: "snippet"}
    opts = Map.merge(defaults, opts)

    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/playlistItems", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(:playlist_item_id, &1))}
      err -> err
    end
  end

  @doc """
  Fetch a list of the videos or playlists based on `type` for the search `query`.

  If the returned items are videos they are represented as an IO list that
  contains a title, an id, a channel title, a publish date and a description.

  If the returned items are playlists they are represented as an IO list that
  contains a title, an id, a channel title and a publish date.
  """
  def search_by_query(type, query, opts \\ %{}) do
    defaults = %{key: Ytaudio.API.api_key, part: "snippet", maxResults: 10, type: Atom.to_string(type), q: query}
    opts = Map.merge(defaults, opts)

    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/search", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(type, &1))}
      err -> err
    end
  end

  @doc """
  Fetch a list of recommended videos based on a video with id `video_id`.

  The returned items are videos that are represented as an IO list that
  contains a title, an id, a channel title and a publish date.
  """
  def recommend(video_id, opts \\ %{}) do
    defaults = %{key: Ytaudio.API.api_key, part: "snippet", maxResults: 10, type: "video", relatedToVideoId: video_id}
    opts = Map.merge(defaults, opts)

    case Ytaudio.API.get(Ytaudio.API.endpoint <> "/search", opts) do
      {:ok, response} ->
        {:ok, Enum.map(response["items"], &parse!(:rec_video, &1))}
      err -> err
    end
  end

  defp parse!(type, body) do
    case parse(type, body) do
      {:ok, data} -> data
      {:error, body} -> raise "Parse error occured! #{body}"
    end
  end

  defp parse(:single_detail, %{"snippet" => snippet}) do
    {:ok,
      [ snippet["title"],
        "\nChannel: ", snippet["channelTitle"],
        "\n", snippet["publishedAt"],
        "\n", snippet["description"],
        "\n\n"
      ]
    }
  end

  defp parse(:video, %{"snippet" => snippet, "id" => %{"videoId" => video_id}}) do
    {:ok,
      [ snippet["title"],
        "\nid: ", video_id,
        "\nChannel: ", snippet["channelTitle"],
        "\n", snippet["publishedAt"],
        "\n", snippet["description"],
        "\n\n"
      ]
    }
  end

  defp parse(:rec_video, %{"snippet" => snippet, "id" => %{"videoId" => video_id}}) do
    {:ok,
      [ snippet["title"],
        "\nid: ", video_id,
        "\nChannel: ", snippet["channelTitle"],
        "\n", snippet["publishedAt"],
        "\n\n"
      ]
    }
  end

  defp parse(:playlist, %{"snippet" => snippet, "id" => %{"playlistId" => playlist_id}}) do
    {:ok,
      [ snippet["title"],
        "\nid: ", playlist_id,
        "\nChannel: ", snippet["channelTitle"],
        "\n", snippet["publishedAt"],
        "\n\n"
      ]
    }
  end

  defp parse(:playlist_item, %{"snippet" => snippet}) do
    {:ok,
      [ snippet["title"],
        "\nid: ", snippet["resourceId"]["videoId"],
        "\nChannel: ", snippet["channelTitle"],
        "\n", snippet["publishedAt"],
        "\n\n"
      ]
    }
  end

  defp parse(:playlist_item_id, %{"snippet" => snippet}) do
    {:ok, snippet["resourceId"]["videoId"]}
  end

  defp parse(_, body) do
    {:error, body}
  end
end
