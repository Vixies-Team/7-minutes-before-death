extends HSlider

@export var music_bus_name: String

var audio_bus_id;
func _ready():
	audio_bus_id = AudioServer.get_bus_index(music_bus_name)

	value = Settings.music_volume
	AudioServer.set_bus_volume_db(
		audio_bus_id,
		linear_to_db(Settings.music_volume)
	)

func _on_value_changed(value: float) -> void:
	Settings.music_volume = value
	AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(value))
