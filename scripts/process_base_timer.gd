extends Node
class_name ProcessBaseTimer

@export var node:Node
@export var method_name:String
@export var target:int

var counter:int = 0
var tick:float = 1
var timer:float = 0
var is_execed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_execed:
		return
		
	timer += delta
	if timer > tick:
		timer -= tick;
		counter += 1;
		if counter > target:
			call_method()
	pass
	
func call_method():
	if node.has_method(method_name):
		node.call(method_name)
		is_execed = true
	else:
		push_error("%s 没有方法 %s" % [node.name,method_name])
