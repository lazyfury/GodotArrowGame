extends Node

var parent:CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	parent.velocity = Vector2(-30,980)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#path_follow.progress += delta * 100
	pass

func _physics_process(delta: float) -> void:
	if parent:
		parent.move_and_slide()
	pass
