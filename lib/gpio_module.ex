defmodule GpioModule do
	defstruct current_led_pid: nil, pid_map: %{}

	def start_gpio(name, input_pin, led_pin, state) do
		{:ok, pid} = Gpio.start_link(input_pin, :input)
		:ok = Gpio.set_int(pid, :both)
		{:ok, led_pid} = Gpio.start_link(led_pin, :output)
		pid_map = Dict.put_new(state.pid_map, input_pin, %{:name => name, :led_pid => led_pid})
		state = %{state | pid_map: pid_map}
		{:ok, state}
	end

  def listen_for_change(state) do
		receive do
			{:gpio_interrupt, input_pin, :rising} ->
				IO.puts "got rising #{input_pin}"
				channel = state.pid_map[input_pin]
				led_pid = channel[:led_pid]
				if state.current_led_pid != nil and
					 state.current_led_pid != led_pid do
						Gpio.write(state.current_led_pid, 0) #turn off last led
				end
				Gpio.write(led_pid, 1)
				state = %{state | current_led_pid: led_pid}
				listen_for_change(state)
				
			{:gpio_interrupt, input_pin, :falling} ->
					IO.puts "got falling #{input_pin}"
					channel = state.pid_map[input_pin]
					led_pid = channel[:led_pid]
					if state.current_led_pid == led_pid do
							Gpio.write(state.current_led_pid, 0) #turn off last led
							state = %{state | current_led_pid: nil}
					end
					listen_for_change(state)
					
			{:gpio_interrupt, _pin, _state} ->     
				listen_for_change(state)
		end
	end
end
