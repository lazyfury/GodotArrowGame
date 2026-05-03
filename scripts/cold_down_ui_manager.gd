extends Control

@export var game_manager:Node
@onready var texture_progress_bar: TextureProgressBar = $HBoxContainer/Control/TextureProgressBar
@onready var cd_label_2: Label = $HBoxContainer/CDLabel2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var timer:float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 0.1:
		timer -= 0.1
		if game_manager.get_local_player() !=null:
			game_manager.get_local_player().ability_cold_d_own.update(cd_label_2,texture_progress_bar)
	pass
