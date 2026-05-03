extends Line2D

var parent:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_point(parent.global_position)
	if points.size() > 24:
		remove_point(0)
