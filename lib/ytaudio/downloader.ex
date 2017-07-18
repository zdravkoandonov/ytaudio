defmodule Ytaudio.Downloader do
  @doc """
  Downloads a single video with id `id`
  """
  def download_single_audio(id) do
    port = Port.open({:spawn, "/home/zdravko/source/repos/ytaudio/ytdl.sh #{id}"}, [:binary])

    receive do
      {^port, {:data, result}} ->
        IO.write(result)
    end

    receive do
      {^port, {:data, result}} ->
        IO.write(result)
    end
  end

  @doc """
  Downloads all videos  with ids from the `ids` list

  Start a new task for every video using `Ytaudio.Downloader.download_single_audio/1`
  """
  def download_playlist(ids) do
    ids
    |> Enum.map(&Task.async(Ytaudio.Downloader, :download_single_audio, [&1]))
    |> Enum.map(&Task.await(&1, 30000))
  end
end
