extends RigidBody2D


@export var hit_effect_scene:PackedScene = preload("uid://cyjr5vd5dp3w")
@export var debris_scene: PackedScene = preload("uid://bqcvuogt42bp3")
@export var debris_count: int = 6
@export var explosion_force: float = 600.0
@export var upward_force: float = 100.0
@export var spread: float = 1.0

@onready var health_component: HealthComponent = $HealthComponent

@onready var label: Label = $Label


var random:RandomNumberGenerator = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_effect_scene.instantiate()
	
	health_component.connect("hp_change",on_hp_change)
	on_hp_change(0)
	pass # Replace with function body.

func on_hp_change(hp:float):
	label.text = "%d/%d" % [health_component.hp,health_component.max_hp]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_damage(damage:float,_position:Vector2,normal:Vector2) -> void:
	var effect:HitParticle = hit_effect_scene.instantiate()
	effect.global_position = _position
	get_tree().current_scene.add_child(effect)
	effect.play()
	
	health_component.damage(damage)
	if health_component.is_dead():
		break_into_debris(_position)
	
	
func break_into_debris(hit_position: Vector2):
	# ❗ 隐藏本体
	visible = false
	set_process(false)
	set_physics_process(false)

	# 💥 生成碎块
	for i in debris_count:
		var debris = debris_scene.instantiate()
		
		get_tree().current_scene.add_child(debris)
		debris.global_position = global_position
		debris.angular_velocity = randf_range(-1, 1)
		debris.scale = Vector2.ONE * randf_range(0.8, 2)
		# 随机方向
		# 🎯 随机水平扩散
		var horizontal = Vector2.RIGHT.rotated(randf() * TAU) * spread

		# 🎯 固定向上
		var upward = Vector2.UP * upward_force

		# 👉 合成方向
		var impulse = (horizontal + upward).normalized() * explosion_force * random.randf_range(0.2,1)

		# 加冲力
		if debris is RigidBody2D:
			debris.apply_impulse(impulse)

	# 🕒 延迟销毁本体
	await get_tree().create_timer(0.2).timeout
	queue_free()
