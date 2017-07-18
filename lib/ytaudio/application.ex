defmodule Ytaudio.Application do
  use Application

  @doc """
  Starts the application with the specified supervision tree
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Task.Supervisor, [[name: Ytaudio.TaskSupervisor]]),
      worker(Task, [Ytaudio.Server, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: Ytaudio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
