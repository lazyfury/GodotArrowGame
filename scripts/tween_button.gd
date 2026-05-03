extends BaseButton

var tween: Tween

func _ready():
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)
	button_down.connect(_on_press)
	button_up.connect(_on_release)

	# 初始化状态
	modulate.a = 0.8
	scale = Vector2.ONE


func _kill_tween():
	if tween and tween.is_running():
		tween.kill()


func _on_hover():
	_kill_tween()
	tween = create_tween()

	tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.12)


func _on_exit():
	_kill_tween()
	tween = create_tween()

	tween.tween_property(self, "scale", Vector2.ONE, 0.15)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "modulate:a", 0.8, 0.15)


func _on_press():
	_kill_tween()
	tween = create_tween()

	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.08)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(self, "modulate:a", 0.9, 0.08)


func _on_release():
	# 松开时回到 hover 状态（如果鼠标还在按钮上）
	if get_rect().has_point(get_local_mouse_position()):
		_on_hover()
	else:
		_on_exit()
