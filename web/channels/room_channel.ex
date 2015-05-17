defmodule Chat.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  `{:ok, socket}` to authorize subscription for channel for requested topic

  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})
		state = %GpioModule{}
    {:ok, state} = GpioModule.start_gpio("channel blue", 17, 5, state)
    {:ok, state} = GpioModule.start_gpio("channel red", 18, 6, state)
    {:ok, state} = GpioModule.start_gpio("channel green", 22, 13, state)
		GpioModule.listen_for_change(state)
    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    :ignore
  end

  def handle_info({:after_join, msg}, socket) do
    Logger.debug "> join #{socket.topic}"
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
	
  def handle_info(:ping, socket) do
		Logger.debug "ping!"
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug "> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
		body = msg["body"]
		Logger.debug "new message #{body}"
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, msg["body"]}, assign(socket, :user, msg["user"])}
  end
end
