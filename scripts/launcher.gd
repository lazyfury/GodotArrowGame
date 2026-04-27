extends Node2D

@export var projectilePrefabs:PackedScene

@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $"../Label"
@onready var preview_line_2d: Line2D = $"../PreviewLine2D"
@onready var arrow_follow_marker_2d: Marker2D = $"../ArrowFollowMarker2D"
@onready var phantom_camera_2d: PhantomCamera2D = $"../../Camera2D/PhantomCamera2D"


@export var max_charge_time: float = 1.5   # 最大蓄力时间（秒）
@export var min_power: float = 0.3         # 最小力度
@export var max_power: float = 1.5         # 最大力度
var current_power:float = 0

var is_dragging := false
var drag_start: Vector2
var drag_current: Vector2

@export var max_drag_distance := 400.0

var is_charging: bool = false
var charge_time: float = 0.0

var random = RandomNumberGenerator.new()

var projectile_temp_inst:Projectile2D
var current_projectile_speed:float:
	get:
		#todo 改成切换装备的时候初始化projectile_temp_inst
		if projectile_temp_inst == null:
			print("init current_projectile_speed")
			projectile_temp_inst = projectilePrefabs.instantiate()
		return projectile_temp_inst.speed
		
var last_arrow:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(true)  # 如果用 _unhandled_input
	
	pass # Replace with function body.

var t:float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_charging:
		charge_time += delta
		
	trajectory_sim(delta)	
	
	label.text = "%.2f/%.2f" % [current_power,max_power]
	#var mouse_pos = get_global_mouse_position()
	#var dir = mouse_pos - global_position
	#rotation = dir.angle()
	pass
	
func trajectory_sim(delta:float)->void:
	if is_dragging:
		t+=delta
		if t < 0.1:
			return
		t-0.1
		
		var drag_vec = drag_current - drag_start

	# 👉 限制最大距离
		var dist = min(drag_vec.length(), max_drag_distance)

	# 👉 方向（注意：通常要反向）
		var direction = -drag_vec.normalized()
		# 👉 临时“模拟子弹”
		preview_line_2d.visible = true
		# 同步参数（关键）
		#sim.velocity = direction * speed * power
		var t = dist / max_drag_distance
		var power = lerp(min_power, max_power, t)
		var points = Projectile2D.simulate(marker_2d.global_position, 12, 0.05,-drag_vec.normalized(),current_projectile_speed * power)
		# 👉 更新 Line2D
		preview_line_2d.clear_points()
		for p in points:
			preview_line_2d.add_point(preview_line_2d.to_local(p))
	else:
		preview_line_2d.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and false:
			if event.pressed:
				start_charge()
			else:
				release_charge()
				
	#滑动控制角度和蓄力	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()
			else:
				end_drag()
	elif event is InputEventMouseMotion and is_dragging:
		update_drag()

			
func start_drag():
	is_dragging = true
	drag_start = get_viewport().get_mouse_position()
	drag_current = drag_start
	arrow_follow_marker_2d.back_to_tower()

func update_drag():
	var _drag_current = get_viewport().get_mouse_position()
	var drag_vec = _drag_current - drag_start
		
	drag_current = _drag_current
		
	# 👉 限制最大距离
	var dist = min(drag_vec.length(), max_drag_distance)

	# 👉 方向（注意：通常要反向）
	var direction = -drag_vec.normalized()
	
	
	rotation = direction.angle()
	
	# 👉 力量（映射）
	var t = dist / max_drag_distance
	var power = lerp(min_power, max_power, t)
	
	current_power = power

func end_drag():
	if not is_dragging:
		return

	is_dragging = false

	var drag_vec = drag_current - drag_start

	# 👉 限制最大距离
	var dist = min(drag_vec.length(), max_drag_distance)

	# 👉 方向（注意：通常要反向）
	var direction = -drag_vec.normalized()


	# 👉 力量（映射）
	var t = dist / max_drag_distance
	var power = lerp(min_power, max_power, t)

	shoot(direction, power)
	
func start_charge():
	is_charging = true
	charge_time = 0.0



func release_charge():
	if not is_charging:
		return
	is_charging = false
	var t = clamp(charge_time / max_charge_time, 0.0, 1.0)
	var power = lerp(min_power, max_power, t)
	var dir = (get_global_mouse_position() - global_position).normalized()
	shoot(dir,power + random.randfn(0,0.1))

func shoot(dir:Vector2,power:float):
	print("debug")
	var projectile:Projectile2D = projectilePrefabs.instantiate()

	projectile.global_position = marker_2d.global_position


	projectile.motion_type = projectile.MotionType.PARABOLA
	projectile.setup(dir, power)
	projectile.phantom_camera_2d = phantom_camera_2d

	get_tree().current_scene.add_child(projectile)
	
	last_arrow = projectile
	
	current_power = 0
	
	arrow_follow_marker_2d.watch = projectile
	phantom_camera_2d.follow_target = projectile
	
