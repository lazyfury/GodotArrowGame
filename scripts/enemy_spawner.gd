extends Node

@export var spawner: Node
@export var init_position: Node2D

const ENEMY = preload("uid://bkcv8xi72hg8u")

# -----------------------------
# 波次配置
# -----------------------------
@export var waves: Array[Dictionary] = [
	{"count": 12},
	{"count": 20},
	{"count": 30}
]

# -----------------------------
# 节奏控制
# -----------------------------
@export var batch_min: int = 2
@export var batch_max: int = 3
@export var batch_interval: float = 1.5
@export var max_global_enemies: int = 10

# -----------------------------
# 状态
# -----------------------------
var current_wave := 0

var remaining_in_wave := 0
var batch_timer := 0.0
var waiting := false


# -----------------------------
# init
# -----------------------------
func _ready() -> void:
	_start_wave()


# -----------------------------
# 主循环
# -----------------------------
func _process(delta: float) -> void:
	if current_wave >= waves.size():
		return

	var global_count = get_global_enemy_count()

	# ❗ 超过上限：暂停本轮节奏
	if global_count >= max_global_enemies:
		return

	batch_timer += delta

	if waiting:
		if batch_timer >= batch_interval:
			waiting = false
			batch_timer = 0.0
		return

	# -----------------------------
	# 生成 batch
	# -----------------------------
	if batch_timer >= batch_interval:
		batch_timer = 0.0

		var batch_size = randi_range(batch_min, batch_max)
		batch_size = min(batch_size, remaining_in_wave)

		for i in batch_size:
			if get_global_enemy_count() >= max_global_enemies:
				break
			spawn_enemy()

			remaining_in_wave -= 1

		waiting = true

	# -----------------------------
	# wave 完成
	# -----------------------------
	if remaining_in_wave <= 0 and get_global_enemy_count() == 0:
		_next_wave()


# -----------------------------
# spawn
# -----------------------------
func spawn_enemy() -> void:
	var enemy = ENEMY.instantiate()
	enemy.global_position = init_position.global_position + Vector2(randi_range(-50,100),0)
	spawner.add_child(enemy)


# -----------------------------
# wave
# -----------------------------
func _start_wave() -> void:
	remaining_in_wave = waves[current_wave]["count"]
	batch_timer = 0.0
	waiting = false


func _next_wave() -> void:
	current_wave += 1
	if current_wave >= waves.size():
		return
	_start_wave()


# -----------------------------
# global enemy count
# -----------------------------
func get_global_enemy_count() -> int:
	return get_tree().get_nodes_in_group("enemy").size()
