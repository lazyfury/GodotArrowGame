extends PointLight2D

@export var base_scale: float = 1     # 基础大小
@export var amplitude: float = 0.1      # 变化幅度
@export var speed: float = 2.0          # 律动速度

var time_passed: float = 0.0

func _process(delta):
	time_passed += delta * speed
	
	var pulse = sin(time_passed)  # -1 ~ 1
	texture_scale = base_scale + pulse * amplitude
