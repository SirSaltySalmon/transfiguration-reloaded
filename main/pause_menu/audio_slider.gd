extends HSlider

@export var bus_index := 0

func _ready():
	value = AudioServer.get_bus_volume_linear(bus_index) * 100.0

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(bus_index, value / 100.0)
