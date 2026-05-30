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

@onready var head = $Head
@onready var camera = $Head/Camera3D

func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_camera_mouse = true

func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_camera_mouse = false
	
func _ready():
	capture_mouse()
	camera_origin = camera.position

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		release_mouse()

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

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
