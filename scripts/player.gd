extends CharacterBody3D

const SPEED := 1.5
const JUMP_VELOCITY := 4.5
@onready var step_player: AnimationPlayer = $step_player

# Mouse Look
const MOUSE_SENS := 0.005

# Head Bob
const BOB_FREQ := 1.8
const BOB_AMP := 0.015

var bob_time := 0.0
var camera_origin : Vector3
var is_camera_mouse = false
var is_paused = false
var is_interact = false
var time_count = 420
var good_memories = 1
var bad_memories = 1
var is_ending = false

@onready var eye_canvas: CanvasLayer = $Head/Camera3D/EyeCanvas
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var pause: Control = $Head/Camera3D/Pause
@onready var cross_hair: ColorRect = $Head/Camera3D/EyeCanvas/CrossHair
@onready var time: Label = $Head/Camera3D/Time
@onready var timer: Timer = $Timer
@onready var interact_ray = $Head/Camera3D/RayCast3D
@onready var interact_label: Label = $Head/Camera3D/Interact
@onready var mirror_interact: Control = $Head/Camera3D/Mirror_Interact
@onready var fade_ending: ColorRect = $Head/Camera3D/EyeCanvas/fade_ending
@onready var eye_timer: Timer = $EyeTimer

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _ready():
	capture_mouse()
	camera_origin = camera.position
	is_camera_mouse = false

func _process(delta: float) -> void:
	if is_ending:
		step_player.stop()
		return
	interact_label.visible = false

	if interact_ray.is_colliding():
		var target = interact_ray.get_collider()
		
		if target.is_in_group("door"):
			interact_label.visible = true
			interact_label.text = "Interact Door [E]"
		elif target.is_in_group("couch"):
			pass
		elif target.is_in_group("mirror"):
			interact_label.visible = true
			interact_label.text = "Interact Mirror [E]"

func _input(event):
	if is_ending: return
	if event.is_action_pressed("ui_cancel") and !is_paused:
		release_mouse()
		cross_hair.visible = false
		is_paused = true
		pause.visible = true
		get_tree().paused = true
	else:
		is_paused = false
		cross_hair.visible = true
	
	if !is_interact:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				capture_mouse()
			
		if event is InputEventMouseMotion and is_camera_mouse:
			# Kiri kanan
			rotate_y(-event.relative.x * MOUSE_SENS)

			# Atas bawah
			head.rotate_x(-event.relative.y * MOUSE_SENS)

			head.rotation.x = clamp(
				head.rotation.x,
				deg_to_rad(-89),
				deg_to_rad(89)
			)

func _physics_process(delta: float) -> void:
	if is_ending: return
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Movement
	var input_dir := Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)
	
	if (input_dir != Vector2.ZERO): step_player.play("step")
	else: step_player.stop()
	
	var direction := (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 4.0)
		velocity.z = move_toward(velocity.z, 0.0, SPEED * 4.0)
		
	#Interact
	if Input.is_action_just_pressed("interact"):
		interact()
		
	move_and_slide()

	_update_headbob(delta)

func _update_headbob(delta):
	var horizontal_speed = Vector2(
		velocity.x,
		velocity.z
	).length()

	if horizontal_speed > 0.1 and is_on_floor():
		bob_time += delta * horizontal_speed

		camera.position.y = (
			camera_origin.y
			+ sin(bob_time * TAU * BOB_FREQ)
			* BOB_AMP
		)
	else:
		camera.position.y = lerp(
			camera.position.y,
			camera_origin.y,
			delta * 8.0
		)

func seconds_to_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [minutes, secs]

func _on_timer_timeout() -> void:
	if !is_camera_mouse: return
	time_count -= 1
	if (time_count < 0):
		is_ending = true
		timer.stop()
		eye_timer.stop()
		release_mouse()
		if good_memories <= 0 and bad_memories <= 0:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			# TODO: kasih jumpscare muka iki
		elif good_memories > bad_memories:
			fade_ending.mouse_filter = 0 # Set mouse filter to Stop
			fade_ending.color.r = 127.0 / 255.0
			fade_ending.color.g = 127.0 / 255.0
			fade_ending.color.b = 127.0 / 255.0
			var tween = create_tween()
			tween.tween_property(
				fade_ending,
				"color:a",
				1.0,
				7
			)
			await tween.finished
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif bad_memories > good_memories:
			fade_ending.mouse_filter = 0 # Set mouse filter to Stop
			fade_ending.color.r = 0
			fade_ending.color.g = 0
			fade_ending.color.b = 0
			
			var tween = create_tween()
			tween.tween_property(
				fade_ending,
				"color:a",
				1.0,
				7
			)
			
			await tween.finished
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif bad_memories == good_memories:
			fade_ending.mouse_filter = 0 # Set mouse filter to Stop
			fade_ending.color.r = 255
			fade_ending.color.g = 255
			fade_ending.color.b = 255
			
			var tween = create_tween()
			tween.tween_property(
				fade_ending,
				"color:a",
				1.0,
				7
			)
			
			await tween.finished
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		time.text = seconds_to_time(time_count)

func _on_eye_timer_timeout() -> void:
	await eye_canvas.animate_open(0.0, 0.10)
	await eye_canvas.animate_open(1.0, 0.15)
	
func interact():
	if !interact_ray.is_colliding():
		return

	var target = interact_ray.get_collider()
	
	if target.has_method("interact"):
		target.interact()
	elif target.is_in_group("mirror"):
		release_mouse()
		is_interact = true
		mirror_interact.visible = true
