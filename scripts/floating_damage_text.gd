extends Node2D
class_name FloatingDamgeText

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setup(text:String,font_size:int = 18,font_color:Color = Color.WHITE):
	label.text = text
	label.pivot_offset = label.size / 2
	label.label_settings.font_size = font_size
	label.label_settings.font_color = font_color
	pass
