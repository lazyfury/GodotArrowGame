extends GPUParticles2D
class_name HitParticle

@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play()->void:
	self.restart()
	if gpu_particles_2d_2 != null:
		gpu_particles_2d_2.restart()
		
	await get_tree().create_timer(2.0).timeout
	queue_free()
