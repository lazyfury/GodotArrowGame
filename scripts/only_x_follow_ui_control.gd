extends Control

var target:Node2D
@export var distance:float = -10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.lerp(Vector2(target.global_position.x,target.global_position.y + distance),10 * delta)
	pass
