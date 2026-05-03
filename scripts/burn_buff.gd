extends Buff
class_name BurnningBuff

@export var tick:float = 5
@export var damage:float = 10

var t:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	if t > tick:
		t -= tick
		for target:Node2D in get_overlapping_bodies():
			if target.has_node("HealthComponent"):
				var health:HealthComponent = target.get_node("HealthComponent")
				if health != null:
					health.damage(damage)
