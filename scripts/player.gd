extends CharacterBody3D

const SPEED := 1.5
const JUMP_VELOCITY := 4.5

# Mouse Look
const MOUSE_SENS := 0.005

# Head Bob
const BOB_FREQ := 1.8
const BOB_AMP := 0.015

var bob_time := 0.0
var camera_origin : Vector3
var is_camera_mouse = false
var is_paused = false
var time_count = 420
var good_memories = 0
var bad_memories = 0

@onready var eye_canvas: CanvasLayer = $Head/Camera3D/EyeCanvas
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var pause: Control = $Head/Camera3D/Pause
@onready var cross_hair: ColorRect = $Head/Camera3D/EyeCanvas/CrossHair
@onready var time: Label = $Head/Camera3D/Time
@onready var timer: Timer = $Timer
@onready var interact_ray = $Head/Camera3D/RayCast3D
@onready var interact_label: Label = $Head/Camera3D/EyeCanvas/Interact

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _ready():
	capture_mouse()
	camera_origin = camera.position
	is_camera_mouse = false

func _process(delta: float) -> void:
	interact_label.visible = false

	if interact_ray.is_colliding():
		var target = interact_ray.get_collider()
		
		if target.is_in_group("door"):
			print("MUNCUL!")
			interact_label.visible = true
			interact_label.text = "Interact Door [E]"
		elif target.is_in_group("couch"):
			#interact_label.visible = true we'll add it later.
			pass

func _input(event):
	if event.is_action_pressed("ui_cancel") and !is_paused:
		release_mouse()
		cross_hair.visible = false
		is_paused = true
		pause.visible = true
		get_tree().paused = true
	else:
		is_paused = false
		cross_hair.visible = true

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
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Movement
	var input_dir := Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)

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
		timer.stop()
		if good_memories <= 0 and bad_memories <= 0:
			pass # ini kasih jumpscare
		elif good_memories > bad_memories:
			pass # neutral ending
		elif bad_memories > good_memories:
			pass # bad ending
		elif bad_memories == good_memories:
			pass # good ending
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
