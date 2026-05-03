extends GPUParticles2D

@onready var 烟雾: GPUParticles2D = $"../烟雾"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = 0.8
	amount = 6
	explosiveness = .8
	烟雾.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_character_body_2d_hit(collision:KinematicCollision2D) -> void:
	await  get_tree().create_timer(.3).timeout
	lifetime = 1.8
	explosiveness = .1
	amount = 24
	烟雾.emitting = true
