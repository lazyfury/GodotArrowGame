extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = 0.8
	amount = 10
	explosiveness = .8
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_character_body_2d_hit() -> void:
	await  get_tree().create_timer(.3).timeout
	lifetime = 1.8
	explosiveness = .1
	amount = 24
