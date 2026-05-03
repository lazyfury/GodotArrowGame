extends Marker2D
class_name ArrowFollow


@export var phantom_camera_2d: PhantomCamera2D
@export var game_manager: Node


var watch:Node2D
var tower: Node2D


var is_backing_to_tower:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = game_manager.get_local_player()
	tower = player
	if player != null:
		player.connect("子弹已发射",follow)
		player.connect("子弹跟踪归位",back_to_tower)
		call_deferred("init_later",player)
	
	pass # Replace with function body.

func init_later(player:Player):
	print("launcher",player.launcher)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_backing_to_tower:
		#phantom_camera_2d.lookahead = false
		watch = null
		global_position = global_position.lerp(tower.global_position,20 * delta)
		var dist:float = (tower.global_position - global_position).length()
		if dist < 100:
			is_backing_to_tower = false
		return
	if watch != null && watch.is_stop != true:
		#phantom_camera_2d.lookahead = true
		global_position = global_position.lerp(watch.global_position,10 * delta)
	pass
	
func follow(node:Node2D):
	is_backing_to_tower = false
	watch = node

func back_to_tower()->void:
	is_backing_to_tower = true
	
