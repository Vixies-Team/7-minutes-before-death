extends Control

func _ready():
	set_anchors_preset(Control.PRESET_CENTER)
	position = Vector2(-4, -4)

func _draw():
	draw_circle(Vector2(4, 4), 4, Color.WHITE)
