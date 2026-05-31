extends CanvasLayer

@onready var top_lid = $TopLid
@onready var bottom_lid = $BottomLid
@onready var blur = $BlurRect
@onready var player: CharacterBody3D = $"../../.."

func _ready():
	wake_up_sequence()

func set_eye_open(value: float):
	top_lid.material.set_shader_parameter(
		"open_amount",
		value
	)

	bottom_lid.material.set_shader_parameter(
		"open_amount",
		value
	)

func wake_up_sequence():

	set_eye_open(0.0)

	await get_tree().create_timer(0.6).timeout

	await animate_open(0.15, 0.25)

	await animate_open(0.0, 0.08)

	await animate_open(0.40, 0.25)

	await animate_open(0.0, 0.10)

	await animate_open(0.75, 0.35)

	await animate_open(0.60, 0.08)

	await animate_open(1.0, 1.0)
	
	player.is_camera_mouse = true
	var blur_tween = create_tween()

	blur_tween.tween_method(
		set_blur,
		8.0,
		0.0,
		3.0
	)

func animate_open(target: float, duration: float):
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_method(
		set_eye_open,
		get_current_open(),
		target,
		duration
	)

	await tween.finished

func get_current_open():
	return top_lid.material.get_shader_parameter(
		"open_amount"
	)

func set_blur(value):
	blur.material.set_shader_parameter(
		"blur_strength",
		value
	)
