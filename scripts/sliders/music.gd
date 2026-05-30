extends HSlider

@export var music_bus_name: String

var audio_bus_id;
func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(music_bus_name)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(value))
