extends Node
class_name HealthComponent

@export var min_hp:float = 0
@export var max_hp:float = 100
@export var hp:float = 100

signal hp_change(hp:float)
signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = clamp(min(hp,max_hp),min_hp,max_hp)
	pass # Replace with function body.

func is_dead() -> bool:
	return hp <= 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage(_damage:float):
	var old_hp = hp
	hp = clamp(hp - _damage,min_hp,max_hp)
	hp_change.emit(hp,hp - old_hp)
	if is_dead():
		dead.emit()
