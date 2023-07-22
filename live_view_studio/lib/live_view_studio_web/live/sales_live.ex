defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :orders)
      :timer.send_interval(1500, self(), :sales)
      :timer.send_interval(10000, self(), :satisfaction)
    end
    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="label">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="label">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="label">
            Satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="/images/refresh.svg" /> Refresh
      </button>
    </div>
    """
  end

  def handle_info(:orders, socket) do
    new_orders = Sales.new_orders()
    {:noreply, assign(socket, new_orders: new_orders)}
  end

  def handle_info(:sales, socket) do
    sales_amount = Sales.sales_amount()
    {:noreply, assign(socket, sales_amount: sales_amount)}
  end

  def handle_info(:satisfaction, socket) do
    satisfaction = Sales.satisfaction()
    {:noreply, assign(socket, satisfaction: satisfaction)}
  end


  def handle_event("refresh", _, socket) do
    # refresh page
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    socket =
      assign(socket,
        new_orders: Sales.new_orders(),
        sales_amount: Sales.sales_amount(),
        satisfaction: Sales.satisfaction()
      )
  end
end
