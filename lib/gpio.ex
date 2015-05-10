defmodule GpioModule do
	uses Elixir_ale
	
	#	defstruct game_id: nil, entries: %{}, moundballs: %{}, prizes: [], winners: %{}, prize_pot: [], current_prize: 0
  defstruct switch_pids: %{}, led_pids: %{}	
	
	def gpio_pins_to_io_pids(channel_name, switch_pin, led_pin) do
		{:ok, switch_pid} = Gpio.start_link(switch_pin, :input)
		{:ok, led_pid} = Gpio.start_link(led_pin, :output)
		Gpio.set_int(pid, :rising)
	end
	
  def init_gpio(io_pin_map) when is_map(io_pin_map) do
		IO.puts "init GPIO"
		# red_light = 19
		# blue_light = 13
		# switch_1 = 4
		# switch_2 = 17
		# iex> {:ok, pid} = Gpio.start_link(17, :input)
		# {:ok, #PID<0.97.0>}
		#
		# iex> Gpio.read(pid)
		# 0
		#
		# # Push the button down
		#
		# iex> Gpio.read(pid)
		# 1
		# If you'd like to get a message when the button is pressed or released, call the set_int function. You can trigger on the :rising edge, :falling edge or :both.
		#
		# iex> Gpio.set_int(pid, :both)
		# :ok
		#
		# iex> flush
		#
		
		
		{:ok, pid} = Gpio.start_link(, :input)
  end

  def check_channel_change do
		
  end

  # A private function
  defp priv do
    :secret_info
  end
end