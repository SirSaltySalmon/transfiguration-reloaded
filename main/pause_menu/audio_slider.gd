extends HSlider

@export var bus_index := 0

const settings_dict = {
	0: "master_vol",
	1: "sfx_vol",
	2: "music_vol",
}

func _ready():
	value = Global.sav.get(settings_dict[bus_index])
	AudioServer.set_bus_volume_linear(bus_index, value / 100.0)

func _on_value_changed(pvalue: float) -> void:
	AudioServer.set_bus_volume_linear(bus_index, pvalue / 100.0)
	Global.sav.set(settings_dict[bus_index], pvalue)
