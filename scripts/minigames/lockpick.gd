@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = $SubViewport.get_texture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Sprite2D.texture != $SubViewport.get_texture():
		$Sprite2D.texture = $SubViewport.get_texture()	
