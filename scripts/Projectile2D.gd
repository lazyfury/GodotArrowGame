extends CharacterBody2D
class_name Projectile2D

enum MotionType {
	LINEAR,
	PARABOLA
}

@export var phantom_camera_2d: PhantomCamera2D

@export var motion_type: MotionType = MotionType.LINEAR

@export var speed: float = 600.0
@export var gravity_scale: float = 1.0
@export var life_time: float = 5.0

@onready var fire_gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_passed: float = 0.0

func _ready():
	# 自动销毁
	await get_tree().create_timer(life_time).timeout
	queue_free()

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
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		on_hit(collision)

func on_hit(collision:KinematicCollision2D):
	# 命中逻辑
	if collision.get_collider().has_method("apply_damage"):
		collision.get_collider().apply_damage(10,collision.get_position(),collision.get_normal())
		
	# 💥 冲量方向（用子弹速度）
	var impulse_dir = velocity.normalized()
	var impulse_strength = 600.0

	var collider = collision.get_collider()
	# 👉 只对 RigidBody2D 生效
	if collider is RigidBody2D:
		collider.apply_impulse(impulse_dir * impulse_strength)
		
	# 🧠 停止运动
	velocity = Vector2.ZERO
	set_physics_process(false)
	
	#phantom_camera_2d.append_follow_targets(self)
	
	reparent(collision.get_collider(), true)  # 👈 关键：保持 global transform
	
	#// wranning
	if fire_gpu_particles_2d != null: fire_gpu_particles_2d.restart()

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
