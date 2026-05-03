extends Node

const BURN_BUFF = preload("uid://b6kusqgv2hsvg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_character_body_2d_hit(collision:KinematicCollision2D) -> void:
	var buff:BurnningBuff = BURN_BUFF.instantiate()
	buff.global_position = collision.get_position()
	var collider = collision.get_collider()
	if collider is Node2D:
		collider.add_child(buff)
