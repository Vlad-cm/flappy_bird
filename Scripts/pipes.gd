extends Node2D


func _process(delta):
	position += Vector2(-2.3, 0)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func spawn(parent: Node):
	position = Vector2(400, randi_range(180, 320))
	z_index = 1
	parent.call_deferred("add_child", self)
