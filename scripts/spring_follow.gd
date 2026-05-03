extends Node2D

enum SpringDirection { Up, Right }

@export var target: Node2D
@export var direction: SpringDirection = SpringDirection.Up

@export var follow_max_distance: float = 500.0
@export var moving_max_distance: float = 200.0

@export var follow_speed: float = 600.0
@export var return_speed: float = 300.0

@export var smoothing: float = 12.0  # ⭐关键：输入滤波

@export var dead_zone: float = 8.0

var offset: float = 0.0
var smooth_target_offset: float = 0.0

var init_position: Vector2
var dir: Vector2

func _ready():
	init_position = global_position
	
	match direction:
		SpringDirection.Up:
			dir = Vector2.UP
		SpringDirection.Right:
			dir = Vector2.RIGHT

func _process(delta):
	if not target:
		return
	
	var to_target = target.global_position - init_position
	var raw_offset = to_target.dot(dir)
	
	# -----------------------------
	# 1️⃣ 输入平滑（核心修复）
	# -----------------------------
	var t = 1.0 - exp(-smoothing * delta)
	smooth_target_offset = lerp(smooth_target_offset, raw_offset, t)
	
	# -----------------------------
	# 2️⃣ 计算目标 offset
	# -----------------------------
	var desired_offset := 0.0
	
	if smooth_target_offset > follow_max_distance:
		var exceed = smooth_target_offset - follow_max_distance
		desired_offset = min(exceed, moving_max_distance)
	
	# -----------------------------
	# 3️⃣ 输出平滑
	# -----------------------------
	var speed = follow_speed if desired_offset != 0.0 else return_speed
	
	offset = move_toward(offset, desired_offset, speed * delta)
	
	# -----------------------------
	# 4️⃣ dead zone（抑制微抖）
	# -----------------------------
	if abs(offset) < dead_zone:
		offset = 0.0
	
	global_position = init_position + dir * offset
