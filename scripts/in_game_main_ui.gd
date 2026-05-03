extends Control

@onready var in_game_setting_ui: Control = $InGameSettingUi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause_game():
	in_game_setting_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
func continue_game():
	get_tree().paused = false

func _on_pause_button_pressed() -> void:
	in_game_setting_ui.visible = true
	in_game_setting_ui.show_ui()
	pause_game()
	pass # Replace with function body.


func _on_in_game_setting_ui_continue_btn_clicked() -> void:
	in_game_setting_ui.hide_ui()
	in_game_setting_ui.visible = false
	continue_game()
	pass # Replace with function body.
