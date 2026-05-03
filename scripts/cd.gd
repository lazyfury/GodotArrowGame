extends Node
class_name AbilityColdDOwn

@export var tick:float = 0.1;
@export var cd_time_default:float = 1.0
var cd_time:float = 0;

var timer:float = 0
var is_ready:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update(label:Label,texture_progress_bar:TextureProgressBar):
	var val = cd_time / cd_time_default * 100
	val = 100 - val
	label.text = "reloading %.2f" % val
	texture_progress_bar.value =  val
	if cd_time <= 0:
		is_ready = true
		label.text = "ready"
		texture_progress_bar.value = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > tick:
		timer -= tick
		if !is_ready:
			cd_time -= tick
	pass

func use():
	cd_time = cd_time_default
	is_ready = false
