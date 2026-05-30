extends CanvasLayer

@onready var play_game: Button = $"Control/VBox/Play Game"
@onready var settings: Button = $Control/VBox/Settings
@onready var exit: Button = $Control/VBox/Exit
@onready var glitch_effects: ColorRect = $"Glitch Effects"
@onready var music: AudioStreamPlayer2D = $Music

var is_random = false
var done_random = false

func stutter(loop):
	var pos = music.get_playback_position()

	while loop[0]:
		music.play(pos)
		await get_tree().create_timer(0.1).timeout

func random_button_first():
	is_random = true
	var loop_stutter = [true]
	stutter(loop_stutter)
	glitch_effects.material.set_shader_parameter("intensity", 1.0)

	var end_time = Time.get_ticks_msec() + 2000

	while Time.get_ticks_msec() < end_time:
		play_game.text = random_string(randi_range(5, 12))
		settings.text = random_string(randi_range(5, 12))
		exit.text = random_string(randi_range(5, 12))
		await get_tree().create_timer(0.05).timeout

	play_game.text = "Settings"
	settings.text = "Play Game"
	exit.text = "Exit"
		
	done_random = true
	is_random = false
	loop_stutter[0] = false
	glitch_effects.material.set_shader_parameter("intensity", 0.0)

func _ready() -> void:
	music.play()
	seed(Time.get_unix_time_from_system())
	
func start_game_menu():
	print("start game")
	pass

func options_menu():
	print("options")
	pass

func random_string(length: int) -> String:
	var chars := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-=[]{}|;:',.<>/?"
	var result := ""

	for i in range(length):
		result += chars[randi() % chars.length()]

	return result

func _on_play_game_pressed() -> void:
	if is_random: return
	
	if !done_random: random_button_first()
	if done_random: options_menu()
	else: random_button_first()
		
func _on_settings_pressed() -> void:
	if is_random: return
	
	if !done_random: random_button_first()
	elif done_random: start_game_menu()
	else: options_menu()

func _on_exit_pressed() -> void:
	if is_random: return
	get_tree().quit()
