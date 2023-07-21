defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  # mount, first callback invoked. Auto called when request comes in through router
  # socket is where all liveview state is stored
  def mount(_params, _session, socket) do
    # assigning state to the socket
    # socket = assign(socket, brightness: 40)
    # IO.inspect(socket.assigns)
    # # returns tuple with two elements
    # {:ok, socket}
    # inline version because assign returns a socket

    IO.inspect(self(), label: "MOUNT")
    {:ok, assign(socket, brightness: 30)}
  end

  # assigns is a map containing the key value pairs we assigned to the socket in mount
  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    # needs to return a template that renders html content
    ~H"""
    <%!-- HEEx template which is static HTML + embedded Elixir--%>
    <h1>Front porch light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%!-- <%= assigns.brightness %>%
          since we are in a template we can access assigned values instead --%>
          <%= @brightness %>%
        </span>
      </div>
      <div>
        <button phx-click="off">
          <img src="/images/light-off.svg" alt="">
        </button>
        <button phx-click="down">
          <img src="/images/down.svg" alt="">
        </button>
        <button phx-click="up">
          <img src="/images/up.svg" alt="">
        </button>
        <button phx-click="on">
          <img src="/images/light-on.svg" alt="">
        </button>
      </div>
    </div>
    """

  end


  def handle_event("on", _, socket) do
    IO.inspect(self(), label: "ON")
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end


  def handle_event("up", _, socket) do
    # brightness = socket.assigns.brightness + 10
    # socket = assign(socket, brightness: brightness)

    # update version
    # &(&1 + 10) is an anonymous function taking argument 1, returning updated val
    # updating socket triggers re render
    # socket = update(socket, :brightness, &(&1 + 10))
    # {:noreply, socket}

    # even shorter
    {:noreply, update(socket, :brightness, &(&1 + 10))}
  end

  def handle_event("down", _, socket) do
    {:noreply, update(socket, :brightness, &(&1 - 10))}
  end

  #render

  #handle_event
end
