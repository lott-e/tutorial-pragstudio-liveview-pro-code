defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Boats
  import LiveViewStudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    # temporary_assigns saves memory for static data
    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <.promo>
      Get your new best friend today!
      <:legal>
        <Heroicons.exclamation_circle />
         Friend is a boat
       </:legal>
    </.promo>
    <div id="boats">
    <%!-- every time filter changes this component auto re renders --%>
    <.filter_form filter={@filter} />

    <div class="boats">
      <.boat :for={boat <- @boats} boat={boat}/>
    </div>

    <%!-- <.boat_list boats={@boats} /> --%>
       <.promo expiration={4}>
         Save 25% on rentals!
         <:legal>
         <Heroicons.exclamation_circle />
          Excluding weekends
         </:legal>
       </.promo>
    </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}
    boats = Boats.list_boats(filter)
    {:noreply, assign(socket, boats: boats, filter: filter)}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end

  attr(:filter, :map, required: true)

  def filter_form(assigns) do
    ~H"""
     <form phx-change="filter">
        <div class="filters">
          <select name="type">
            <%= Phoenix.HTML.Form.options_for_select(
              type_options(),
              @filter.type
            ) %>
          </select>
          <div class="prices">
            <%= for price <- ["$", "$$", "$$$"] do %>
              <input
                type="checkbox"
                name="prices[]"
                value={price}
                id={price}
                checked={price in @filter.prices}
              />
              <label for={price}><%= price %></label>
            <% end %>
            <input type="hidden" name="prices[]" value="" />
          </div>
        </div>
      </form>
    """
  end

  attr(:boat, LiveViewStudio.Boats.Boat, required: true)

  def boat(assigns) do
    ~H"""
        <div class="boat">
          <img src={@boat.image} />
          <div class="content">
            <div class="model">
              <%= @boat.model %>
            </div>
            <div class="details">
              <span class="price">
                <%= @boat.price %>
              </span>
              <span class="type">
                <%= @boat.type %>
              </span>
            </div>
          </div>
      </div>
    """
  end
end
