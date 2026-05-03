extends Node2D
class_name CameraShake2D

# 后坐力 
@export var recoil_distance = 32.0
@export var recoil_time = 0.05
@export var return_time = 0.1
@onready var cam:PhantomCamera2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




var tween: Tween

func shoot_recoil(dir: Vector2,power:float = 1,repeact:float = 1):
	# dir = 子弹方向（单位向量）
	var recoil_offset = -dir.normalized() * recoil_distance * power
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	for i in range(repeact):
		# cam.follow_offset
		# 第一步：瞬间后坐力（往反方向）
		tween.tween_property(cam, "follow_offset", recoil_offset, recoil_time)

		# 第二步：回弹
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(cam, "follow_offset", Vector2.ZERO, return_time)
		
