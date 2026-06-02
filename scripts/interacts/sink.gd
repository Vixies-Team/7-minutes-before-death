extends Control

@onready var plates: Sprite2D = $Panel/Plates
@onready var sponge: Sprite2D = $Panel/Sponge
@onready var hand: Sprite2D = $Panel/Hand
@onready var dirty: TextureRect = $Panel/Dirty
@onready var done_washing: Button = $"Panel/Done Washing"

var wash_progress := 0.0
const MAX_WASH := 100.0

func _ready() -> void:
	done_washing.disabled = true

func _process(delta: float) -> void:
	sponge.global_position = get_global_mouse_position()
	hand.global_position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_wash(delta)

func _wash(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	if dirty.get_global_rect().has_point(mouse_pos):
		wash_progress += 40.0 * delta
		wash_progress = clamp(wash_progress, 0.0, MAX_WASH)

		var alpha = 1.0 - (wash_progress / MAX_WASH)
		dirty.modulate.a = alpha

		if wash_progress >= MAX_WASH:
			dirty.modulate.a = 0.0
			done_washing.disabled = false

func _on_done_washing_pressed() -> void:
	print("Piring bersih!")
