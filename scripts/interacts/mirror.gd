extends Control

@onready var player: CharacterBody3D = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	player.release_mouse()
	player.is_interact = true
	player.mirror_interact.visible = true

func _on_back_pressed() -> void:
	player.capture_mouse()
	player.is_interact = false
	player.mirror_interact.visible = false
	
