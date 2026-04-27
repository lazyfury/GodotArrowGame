extends Line2D

# 痕迹的最大长度（点数）
@export var max_points: int = 50
var last_point:Vector2

func _process(_delta):
	# 检测屏幕点击和移动
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		if last_point != null and (mouse_pos - last_point).length() < 10:
			return
		# 添加新点
		add_point(mouse_pos)
		last_point = mouse_pos
		
		# 限制点数以达到清除旧痕迹的效果
		if get_point_count() > max_points:
			remove_point(0)
	else:
		# 手指离开屏幕时，逐渐清除痕迹（可选）
		if get_point_count() > 0:
			remove_point(0)
