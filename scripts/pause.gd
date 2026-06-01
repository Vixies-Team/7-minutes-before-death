extends Control
@onready var player: CharacterBody3D = $"../../.."
@onready var fade_out: ColorRect = $"../EyeCanvas/FadeOut"
@onready var resume: Control = $Panel/Resume
@onready var options: Control = $Panel/Options

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		capture_mouse()
		get_tree().paused = false
		visible = false


func _on_exit_game_pressed() -> void:
	fade_out.mouse_filter = 0 # Set mouse filter to Stop
	var tween = create_tween()

	tween.tween_property(
		fade_out,
		"color:a",
		1.0,
		1.5
	)

	await tween.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_options_pressed() -> void:
	resume.visible = false
	options.visible = true
	pass # Replace with function body.

func _on_resume_pressed() -> void:
	capture_mouse()
	get_tree().paused = false
	visible = false
	pass # Replace with function body.
