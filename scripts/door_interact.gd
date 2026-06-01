extends StaticBody3D

var is_open = false
@onready var plane_006: MeshInstance3D = $".."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func interact():
	if is_open:
		close_door()
	else:
		open_door()

func open_door():
	animation_player.play("door_open")
	await animation_player.animation_finished
	is_open = true

func close_door():
	animation_player.play("door_closed")
	await animation_player.animation_finished
	is_open = false
