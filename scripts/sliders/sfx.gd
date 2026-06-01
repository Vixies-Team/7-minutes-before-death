extends HSlider

@export var sfx_bus_name: String

var audio_bus_id
func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(sfx_bus_name)

	value = Settings.sfx_volume
	AudioServer.set_bus_volume_db(
		audio_bus_id,
		linear_to_db(Settings.sfx_volume)
	)
	
func _on_value_changed(value: float) -> void:
	Settings.sfx_volume = value

	AudioServer.set_bus_volume_db(
		audio_bus_id,
		linear_to_db(value)
	)
