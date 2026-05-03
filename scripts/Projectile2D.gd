extends CharacterBody2D
class_name Projectile2D

enum MotionType {
	LINEAR,
	PARABOLA
}

signal hit(collision:KinematicCollision2D)

@export var phantom_camera_2d: PhantomCamera2D
@export var camera_shake_2d:CameraShake2D

@export var motion_type: MotionType = MotionType.LINEAR

@export var damage:float = 10.0
@export var speed: float = 600.0
@export var gravity_scale: float = 1.0
@export var life_time: float = 5.0

@export var curve:Curve

@onready var fire_gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var trail_line_2d: Line2D = $Line2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_passed: float = 0.0
var is_stop:bool = false

func _ready():
	#add_to_group("arrow")
	# 自动销毁
	#await get_tree().create_timer(life_time).timeout
	#queue_free()
	pass

func setup(direction: Vector2, power: float = 1.0):
	direction = direction.normalized()

	match motion_type:
		MotionType.LINEAR:
			velocity = direction * speed * power

		MotionType.PARABOLA:
			velocity = direction * speed * power

func _physics_process(delta):
	time_passed += delta

	match motion_type:
		MotionType.LINEAR:
			move_linear(delta)

		MotionType.PARABOLA:
			move_parabola(delta)

func move_linear(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		on_hit(collision)

func move_parabola(delta):
	velocity.y += gravity * gravity_scale * delta
	rotation = velocity.angle() +  velocity.normalized().x * curve.sample(time_passed / 5) * velocity.angle() * 2
	var collision = move_and_collide(velocity * delta)
	if collision:
		on_hit(collision)

func on_hit(collision:KinematicCollision2D):
	
	# 命中逻辑
	if collision.get_collider().has_method("apply_damage"):
		collision.get_collider().apply_damage(damage,collision.get_position(),collision.get_normal())
		
	# 💥 冲量方向（用子弹速度）
	var impulse_dir = velocity.normalized()
	var impulse_strength = 600.0

	var collider = collision.get_collider()
	# 👉 只对 RigidBody2D 生效
	if collider is RigidBody2D:
		collider.apply_impulse(impulse_dir * impulse_strength)
		
	var repeat = 1
	var camera_shake_2d_dir = - collision.get_collider_velocity()
	if collider is StaticBody2D:
		camera_shake_2d_dir = - velocity
	if camera_shake_2d != null: camera_shake_2d.shoot_recoil(-velocity,2,repeat)
	
		
	# 🧠 停止运动
	velocity = Vector2.ZERO
	set_physics_process(false)
	is_stop = true
	
	#phantom_camera_2d.append_follow_targets(self)
	
	
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		reparent(collision.get_collider(), true)  # 👈 关键：保持 global transform
	
	hit.emit(collision)
	#// wranning
	if fire_gpu_particles_2d != null: fire_gpu_particles_2d.restart()
	
	get_tree().create_timer(0.3).connect("timeout",func():
		trail_line_2d.visible = false
	)

static func simulate(start_pos: Vector2, steps: int, dt: float,dir:Vector2,speed:float) -> Array:
	var points: Array = []
	var pos = start_pos
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	#print("dir %v speed %d " % [dir.normalized(),speed])
	var veloc:Vector2 = dir.normalized() * speed
	for p in range(steps):
		points.append(pos)
		veloc.y += gravity * 1 * dt
		pos += veloc * dt
	return points
