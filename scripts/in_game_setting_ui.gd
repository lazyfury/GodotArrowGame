extends Control

signal continue_btn_clicked

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var h_box_container: Control = $HBoxContainer
@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_box_container.visible = false
	texture_rect.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_ui():
	h_box_container.visible = true
	texture_rect.visible = true
	animation_player.play("fade_in")

func hide_ui():
	animation_player.play("fade_out")

func _change_ui_visible():
	h_box_container.visible = false
	texture_rect.visible = false

func _on_texture_button_3_pressed() -> void:
	hide_ui()
	await get_tree().create_timer(0.5).timeout
	continue_btn_clicked.emit()
	pass # Replace with function body.


func _on_restart_texture_button_3_pressed() -> void:
	hide_ui()
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
