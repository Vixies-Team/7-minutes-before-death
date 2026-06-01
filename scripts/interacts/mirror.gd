extends Control

@onready var player: CharacterBody3D = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	player.is_interact = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
