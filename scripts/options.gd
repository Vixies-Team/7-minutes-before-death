extends Control

@onready var resume: Control = $"../Resume"
@onready var options: Control = $"."

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	resume.visible = true
	options.visible = false
	pass # Replace with function body.
