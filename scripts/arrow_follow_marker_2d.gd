extends Marker2D
class_name ArrowFollow

var watch:Node2D

@onready var tower: Node2D = $".."
@onready var phantom_camera_2d: PhantomCamera2D = $"../../Camera2D/PhantomCamera2D"

var is_backing_to_tower:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_backing_to_tower:
		phantom_camera_2d.lookahead = false
		watch = null
		global_position = global_position.lerp(tower.global_position,8 * delta)
		var dist:float = (tower.global_position - global_position).length()
		if dist < 100:
			is_backing_to_tower = false
		return
	if watch != null:
		phantom_camera_2d.lookahead = true
		global_position = global_position.lerp(watch.global_position,20 * delta)
	pass

func back_to_tower()->void:
	is_backing_to_tower = true
	
